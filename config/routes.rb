Rails.application.routes.draw do
  root "static_pages#home"
  # This rule maps requests for the URL /static_pages/home to the home action in the Static Pages controller. By using GET we arrange for the route to respond to a GET request.
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'
end
