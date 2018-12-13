Rails.application.routes.draw do
  #resources 'scrapping' do
	 # collection do
	 #   get 'pull_data'
	 # end
  #end
  match '/scrapping/pull_data' => 'scrapping#pull_data', via: [:get, :post]

  root 'scrapping#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
