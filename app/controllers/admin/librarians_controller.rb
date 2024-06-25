class Admin::LibrariansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :ensure_librarian_role_id, only: [:create]

  def create
     librarian = User.new(librarian_params)
    if librarian.save
      render json: {
        status: 200,
        message: "Librarian created successfully",
        data: UserSerializer.new(librarian).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 422,
        message: "Failed to create librarian",

        errors: librarian.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    librarian = User.find(params[:id])

    if librarian.destroy!
      render json:
      {
        status: 200,
        message: "Librarian deleted successfully",
       }, status: :ok
      else
        render json:{
        status: 422,
        message: "Failed to delete librarian",
        params: params
      }
      end
  end

  def index
    librarians = User.where(role_id: (Role.find_by(name:"librarian").id))
    if librarians.present?
  render json:{
      status: 200,
      data: librarians.map { |librarian| UserSerializer.new(librarian).serializable_hash[:data][:attributes] }
  },  status: :ok
    else
      render json:{
        status: 422,
        message: "Go to hell i din't have any librarian for you.",
      }
    end
  end
  private
  def librarian_params
    params.require(:user).permit(:email, :password, :name, :role_id)
  end

  def ensure_librarian_role_id
  if (Role.find_by(name:"librarian")).id != params[:librarian][:user][:role_id].to_i
    render json: {
        status: 422,
        message: "Failed to create librarian role missmatch",
        params:params,
        }, status: :unprocessable_entity
    end
  end
  end
  def ensure_admin!
  if current_user.role_id != (Role.find_by(name:"admin")).id
    render json: {
        status: 403,
        message: "Access denied. Admin privileges required.",
        params:params
      }, status: :forbidden
  end
end
