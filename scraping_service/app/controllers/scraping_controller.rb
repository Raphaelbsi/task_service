class ScrapingController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'json'

  def index
    scraping_results = ScrapingResult.all
    render json: scraping_results
  end

  def create
    url = params[:url].gsub('comprar', 'api/detail/car') + '&pandora=true'
    task_id = params[:task_id]
    user_id = params[:user_id]

    Rails.logger.info "Fetching data from API: #{url}"

    begin
      data = fetch_data_from_api(url)

      scraping_result = ScrapingResult.new(
        task_id:,
        user_id:,
        make: data[:make],
        model: data[:model],
        price: data[:price],
        city: data[:city],
        year: data[:year],
        km: data[:km],
        transmission: data[:transmission],
        body_type: data[:body_type],
        fuel: data[:fuel],
        final_plate: data[:final_plate],
        color: data[:color],
        trade: data[:trade]
      )

      if scraping_result.save
        puts 'Scraping result saved successfully'
        notify(task_id, user_id, data[:city], data[:year], data[:km])
        render json: { status: 'Scraping completed successfully', data: scraping_result }, status: :created
      else
        puts "Failed to save scraping result: #{scraping_result.errors.full_messages}"
        render json: { errors: scraping_result.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
      render json: { status: 500, error: 'Internal Server Error', message: e.message }, status: :internal_server_error
    end
  end

  private

  def fetch_data_from_api(url)
    uri = URI(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json, text/plain, */*'
    request['Accept-Language'] = 'pt-BR,pt;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6'
    request['Connection'] = 'keep-alive'
    request['Cookie'] =
      '__rtbh.lid=%7B%22eventType%22%3A%22lid%22%2C%22id%22%3A%22ZguFnzDIqYvMsSM1xZiG%22%7D; WebMotorsVisitor=1; _gcl_au=1.1.1944479753.1722785546; __spdt=c4a1ee8436e6449681e9c685778868b0; _fbp=fb.2.1722785546390.345610460548279211; _tt_enable_cookie=1; _ttp=_htsUBgkki3nxVHWGYFtkGLx2tV; __rtbh.uid=%7B%22eventType%22%3A%22uid%22%2C%22id%22%3A%22unknown%22%7D; _pxvid=c170b029-5276-11ef-bd25-307d1de6676e; at_check=true; s_plt=0.89; s_pltp=undefined; AMCVS_3ADD33055666F1A47F000101%40AdobeOrg=1; AMCV_3ADD33055666F1A47F000101%40AdobeOrg=179643557%7CMCIDTS%7C19940%7CMCMID%7C44024780148718260204539009029149509970%7CMCAAMLH-1723396280%7C4%7CMCAAMB-1723396280%7C6G1ynYcLPuiQxYZrsz_pkqfLG9yMXBpb2zX5dvJdYQJzPXImdj0y%7CMCOPTOUT-1722798680s%7CNONE%7CMCSYNCS%7C1083-19947*1085-19947*1086-19947*1087-19947*1088-19947*19913-19947*83349-19947%7CMCSYNCSOP%7C411-19947%7CvVersion%7C5.5.0; WebMotorsDataFormLeads=%7B%22dataForm%22%3A%7B%22uniqueId%22%3A51047580%2C%22listingType%22%3A%22U%22%2C%22vehicleType%22%3A%22car%22%2C%22idGuid%22%3A%22a37ab5b3-7e5b-43f7-adcf-bab1c55f2c40%22%2C%22make%22%3A%22CHEVROLET%22%2C%22makeId%22%3A2%2C%22model%22%3A%22CRUZE%22%2C%22modelId%22%3A3202%2C%22version%22%3A%221.4%20TURBO%20LT%2016V%20FLEX%204P%20AUTOM%C3%81TICO%22%2C%22versionId%22%3A346725%2C%22yearModel%22%3A2023%2C%22yearFabrication%22%3A2022%2C%22price%22%3A104390%2C%22storeName%22%3A%22Localiza%20Seminovos%20Serra%20II%20(VCSER)%22%2C%22storeDocument%22%3A%2216670085120215%22%2C%22sellerId%22%3A3952037%2C%22sellerType%22%3A%22PJ%22%2C%22city%22%3A%22Serra%22%2C%22hyundaiGroup%22%3Afalse%7D%7D; gpv_v39=%2Fwebmotors%2Fcomprar%2Fdetalhe; pxcts=9366b87f-5284-11ef-9a0f-06d3ba4b3f91; s_cc=true; _px3=f88b39be363818bedbba4da1cfd4dc55c3a276ee67167b8e02cb380f97ee54df:BFZHALKZanSDmmWQnjx/81wiS6cUK8hBfswv1YbtxE7sEFTENB/3njOeF4yXZMmB5tEn17jLZ+RCmJG4L+OTFg==:1000:MyWA7GUAPmZwYtW8aHPHvkcMBpxy8J6bNFMpalPOaqhXX2AATXThukWKJ7N/zCBh5mI4KkQeK2vgTvK8j6S4bdnVvDoGhOtVYb0XWbwAmxvK2n4/3KsM2JZTCVjUtRRuBGqhHe30Lu6xOUtdRX7MclCKpnZK8Xss+SL4waqQS9vg9Fpt9+G3OH+P+oYs65ZH3mBNqJg1QVOFT3KvYNyNIlH7qUPNQ4NAlDOJ8hSDdy8=; _pxde=0357c89acc52ea415fc457e6b00152932c56be032f4fc82e312299c0d4540b45:eyJ0aW1lc3RhbXAiOjE3MjI3OTE0ODQzNTh9; _dd_s=rum=1&id=872453f1-a2e7-441a-83fd-062905876298&created=1722791480107&expire=1722792390948; mbox=PC\\#3d3b88e2ac17418ab885e9627bff5443.34_0\\#1786036292|session\\#e299de9151634f18bf99e1392e5e2bab\\#1722793352'
    request['Sec-Fetch-Dest'] = 'empty'
    request['Sec-Fetch-Mode'] = 'cors'
    request['Sec-Fetch-Site'] = 'same-origin'
    request['User-Agent'] =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36 Edg/127.0.0.0'
    request['sec-ch-ua'] = '"Not)A;Brand";v="99", "Microsoft Edge";v="127", "Chromium";v="127"'
    request['sec-ch-ua-mobile'] = '?0'
    request['sec-ch-ua-platform'] = '"macOS"'

    response = https.request(request)

    raise "API request failed with status #{response.code}" unless response.code.to_i == 200

    raise "Expected JSON response but got #{response.content_type}" unless response.content_type == 'application/json'

    data = JSON.parse(response.body)

    {
      make: data.dig('Specification', 'Make', 'Value') || 'N/A',
      model: data.dig('Specification', 'Model', 'Value') || 'N/A',
      price: data.dig('Prices', 'Price').to_s || 'N/A',
      city: data.dig('Seller', 'City') || 'N/A',
      year: data.dig('Specification', 'YearModel').to_s || 'N/A',
      km: data.dig('Specification', 'Odometer').to_s || 'N/A',
      transmission: data.dig('Specification', 'Transmission') || 'N/A',
      body_type: data.dig('Specification', 'BodyType') || 'N/A',
      fuel: data.dig('Specification', 'Fuel') || 'N/A',
      final_plate: data.dig('Specification', 'FinalPlate').to_s || 'N/A',
      color: data.dig('Specification', 'Color', 'Primary') || 'N/A',
      trade: data.dig('VehicleAttributes')&.map { |attr| attr['Name'] }&.join(', ') || 'N/A'
    }
  end

  def notify(task_id, user_id, city, year, km)
    notification_details = "Scraping completed for task #{task_id}: City - #{city}, Year - #{year}, KM - #{km}"
    HTTParty.post('http://notification_service:3000/notifications',
                  body: { notification: { task_id:, user_id:,
                                          details: notification_details } }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  end
end
