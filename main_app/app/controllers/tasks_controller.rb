class TasksController < ApplicationController
  before_action :authenticate_user
  before_action :set_task, only: %i[update destroy]

  def index
    @tasks = Task.all
    render json: @tasks
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = @current_user_id

    Rails.logger.info "Attempting to save task with attributes: #{@task.attributes}"

    if @task.save
      NotifyJob.perform_later(@task)
      TriggerScrapingJob.perform_later(@task) if @task.pending? && @task.url.present?
      render json: { task: @task }, status: :created
    else
      Rails.logger.error("Task creation failed: #{@task.errors.full_messages}")
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      NotifyJob.perform_later(@task)
      TriggerScrapingJob.perform_later(@task) if @task.pending? && @task.url.present?
      render json: { task: @task }, status: :ok
    else
      Rails.logger.error("Task updated failed: #{@task.errors.full_messages}")
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :status, :url)
  end
end
