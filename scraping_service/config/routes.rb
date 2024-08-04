Rails.application.routes.draw do
  post 'scrape', to: 'scraping#create'
  get 'scraping_results', to: 'scraping#index'
end
