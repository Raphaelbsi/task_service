class NotifyJob < ApplicationJob
  queue_as :default

  def perform(task)
    notification_details = "Task #{task.id} was created/updated: Title - #{task.title}, Status - #{task.status}, URL - #{task.url}"
    HTTParty.post(ENV['NOTIFICATION_SERVICE_URL'],
                  body: { notification: { task_id: task.id, user_id: task.user_id,
                                          details: notification_details } }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  rescue StandardError => e
    Rails.logger.error("Notification failed for task #{task.id}: #{e.message}")
    raise e
  end
end

