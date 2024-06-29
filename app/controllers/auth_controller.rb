class AuthController < ApplicationController

  def is_verified_token()
    token = request.headers['Authorization'].split(' ').last
    puts "token in rails :"
    puts token
    puts "request : "
    puts request.body
    puts "action param"
    puts params[:auth][:action]
    if authenticate_user! && current_user.status == 'active'
      render json:{
        user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] ,
        status: 200
      }, status: 200
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

end
