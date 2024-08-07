class TriggerScrapingJob < ApplicationJob
  queue_as :default

  def perform(task)
    HTTParty.post(ENV['SCRAPING_SERVICE_URL'],
                  body: { task_id: task.id, user_id: task.user_id, url: task.url }.to_json,
                  headers: { 'Content-Type' => 'application/json' })
  rescue StandardError => e
    Rails.logger.error("Scraping failed for task #{task.id}: #{e.message}")
    raise e
  end
end
