class ApplicationController < ActionController::API

  def generate_jwt_token(user)
    payload = { user_id: user.id }
    JWT.encode(payload, Rails.application.config.secret_key_base, 'HS256')
  end

  def authenticate_user
    token = request.headers['Authorization']
    begin
      payload, = JWT.decode(token, Rails.application.config.secret_key_base, ['HS256'])
      @current_user = User.find(payload['user_id'])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
    if @current_user
      unless @current_user.status
        render json: { error: 'User not active' }, staus: :unauthorized
      end
    end
  end
end
