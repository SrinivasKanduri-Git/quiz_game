Rails.application.routes.draw do
  resources :users do 
    member do
      put :status_update, to: "users#status_update"
    end
  end
  post "/login", to: "authentication#login"
  resources :quizs do
    member do
      post :take_quiz, to: "quizs#take_quiz"
      put :update_questions, to: "quizs#update_questions"
      delete :delete_questions, to: "quizs#destroy_questions"
    end
  end
end
