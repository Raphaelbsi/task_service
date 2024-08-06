class Task < ApplicationRecord
  enum status: { pending: 0, in_progress: 1, completed: 2 }

  validates :title, presence: true
  validates :status, presence: true
  validates :url, presence: true
  validates :user_id, presence: true
end
