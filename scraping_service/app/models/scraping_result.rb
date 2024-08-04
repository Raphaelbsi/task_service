class ScrapingResult < ApplicationRecord
  validates :task_id, :user_id, :city, :year, :km, :transmission, :body_type, :fuel, :final_plate, :color, :trade,
            presence: true
end
