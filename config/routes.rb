Rails.application.routes.draw do
  resources :survey_responses
  post 'survey_responses/sms' => 'survey_responses#sms'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
