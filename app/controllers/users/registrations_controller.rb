# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  def create
    super
  end

  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?

      render json: {
               status: {code: 200, message: 'Signed up successfully.'},
               params: params,
               user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
             }
    else
      render json: {
               status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"},
               params: params
             }, status: :unprocessable_entity
    end
  end
end
