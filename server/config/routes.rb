Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope "/forms" do
    get "index"   => "forms#index"
    post "create" => "forms#create"
  end

  scope "/users/:api_key" do
    post "create_user" => "users#create_new_user"
    post "update_user" => "users#update_user"
    post "delete_user" => "users#delete_user"
  end

  root to: 'forms#index'
end
