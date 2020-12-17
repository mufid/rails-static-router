Rails.application.routes.draw do
  get '/lucu.txt', to: static('lucu.txt')
  controller :test do
    get :aroute
  end
end
