class AddDetailsToScrapingResults < ActiveRecord::Migration[6.1]
  def change
    add_column :scraping_results, :city, :string
    add_column :scraping_results, :year, :string
    add_column :scraping_results, :km, :string
    add_column :scraping_results, :transmission, :string
    add_column :scraping_results, :body_type, :string
    add_column :scraping_results, :fuel, :string
    add_column :scraping_results, :final_plate, :string
    add_column :scraping_results, :color, :string
    add_column :scraping_results, :trade, :string
  end
end
