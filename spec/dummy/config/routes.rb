Rails.application.routes.draw do
  get '/lucu.txt', to: static('lucu.txt')
end
