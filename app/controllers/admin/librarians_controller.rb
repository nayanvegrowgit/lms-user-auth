class Admin::LibrariansController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :ensure_librarian_role_id, only: [:create]

  def create
    librarian = User.new(librarian_params)
    if librarian.save
      render json: {
               message: "Librarian created successfully",
               data: UserSerializer.new(librarian).serializable_hash[:data][:attributes]
             }, status: :ok
    else
      render json: {
               message: "Failed to create librarian",
               error: librarian.errors.full_messages
             }, status: :unprocessable_entity
    end
  end

  def updatestatus()
    puts "id"
    puts params[:id]
    librarian = User.find(params[:id])
    puts "librarian"
    puts librarian
    status = librarian.status
    if status == 'inactive'
      librarian.update!(status: 'active');
    else
      librarian.update!(status: 'inactive');
    end
    if librarian.status != status
      render json:
               {
                 message: "Success",
               }, status: :ok
    else
      render json:{
               message: "Failed",
             }, status: 422
    end
  end

  def index
    librarians = User.where(role_id: (Role.find_by(name:"librarian").id))
    if librarians.present?
      render json:{
               data: librarians.map { |librarian| UserSerializer.new(librarian).serializable_hash[:data][:attributes] }
             },  status: :ok
    else
      render json:{
               message: "No data Found",
             },status: 422
    end
  end


  def promotetoadmin()
    puts "id"
    puts params[:id]
    librarian = User.find(params[:id])
    puts "librarian"
    puts librarian
    status = librarian.status
    if status == 'active'
      librarian.update!(role_id: 1);
      if librarian.role_id == 1
        render json:
                 {
                   message: "Success",
                 }, status: :ok
      else
        render json:{
                 message: "Failed",
               }, status: :failed
      end
    else
      render json:{
               message: "Librarian is not active, first activate the librarian and then try again",
             }, status: :failed
    end
  end

  private
  def librarian_params
    params.require(:user).permit(:email, :password, :name, :role_id)
  end

  def ensure_librarian_role_id
    if (Role.find_by(name:"librarian")).id != params[:librarian][:user][:role_id].to_i
      render json: {
               message: "Failed to create librarian role missmatch",
               params:params,
             }, status: :unprocessable_entity
    end
  end
end
def ensure_admin!
  if current_user.role_id != (Role.find_by(name:"admin")).id
    render json: {
             message: "Access denied. Admin privileges required.",
             params:params
           }, status: :unauthorized
  end
end
