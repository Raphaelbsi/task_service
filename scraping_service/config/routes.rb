Rails.application.routes.draw do
  post 'scrape', to: 'scraping#create'
end
