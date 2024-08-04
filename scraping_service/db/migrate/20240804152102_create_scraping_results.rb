class CreateScrapingResults < ActiveRecord::Migration[6.1]
  def change
    create_table :scraping_results do |t|
      t.integer :task_id
      t.integer :user_id
      t.string :make
      t.string :model
      t.string :price

      t.timestamps
    end
  end
end
