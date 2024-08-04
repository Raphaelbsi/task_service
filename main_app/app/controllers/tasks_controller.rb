class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user_id

    if @task.save
      notify(@task)
      trigger_scraping(@task) if @task.pending? && @task.url.present?
      render json: { task: @task }, status: :created
    else
      render :new
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      notify(@task)
      trigger_scraping(@task) if @task.pending? && @task.url.present?
      render json: { task: @task }, status: :update
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Tarefa excluída com sucesso.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :status, :url)
  end

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

  def notify(task)
    notification_details = "Task #{task.id} was created/updated: Title - #{task.title}, Status - #{task.status}, URL - #{task.url}"
    HTTParty.post('http://notification_service:3000/notifications',
                  body: { notification: { task_id: task.id, user_id: task.user_id,
                                          details: notification_details } }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  end

  def trigger_scraping(task)
    HTTParty.post('http://scraping_service:3000/scrape',
                  body: { task_id: task.id, user_id: task.user_id, url: task.url }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  end
end
