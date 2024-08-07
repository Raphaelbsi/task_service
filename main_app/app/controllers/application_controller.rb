class ApplicationController < ActionController::API
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    url = URI("http://auth_service:3000/verify?token=#{token}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    if response.is_a?(Net::HTTPSuccess)
      user_data = JSON.parse(response.body)
      @current_user_id = user_data['user_id']
    else
      Rails.logger.error("Failed to authenticate user. Response: #{response.body}")
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
