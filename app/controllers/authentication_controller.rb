class AuthenticationController < ApplicationController
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = generate_jwt_token(user)
      render json: { user:, token: }
    else
      render json: { errors: 'Invalid user name or password' }, status: :unprocessable_entity
    end
  end
end
