class Admin::MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_authorised!
  before_action :ensure_member_role_id, only: [:create]

  def create
    member = User.new(member_params)
    if member.save
      render json: {
               message: "Member created successfully",
               data: UserSerializer.new(member).serializable_hash[:data][:attributes]
             }, status: :ok
    else
      render json: {
               member: "Failed to create ",
               errors: member.errors.full_messages
             }, status: :unprocessable_entity
    end
  end

  def list()
    members = User.where(role_id: (Role.find_by(name:"member").id)).offset(params[:offset]).limit(params[:limit])
    if members.present?
      render json:{
               data: members.map { |member| UserSerializer.new(member).serializable_hash[:data][:attributes] }
             },  status: :ok
    else
      render json:{
               message: "Go to hell i din't have any member for you.",
             }, status: 204
    end
  end

  def updatestatus()

    member = User.find(params[:id])

    status = member.status
    if status == 'inactive'
      member.update!(status: 'active');
    else
      member.update!(status: 'inactive');
    end
    if member.status != status
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



  private
  def member_params
    params.require(:user).permit(:email, :password, :name, :role_id)
  end



  def ensure_member_role_id
    if (Role.find_by(name:"member")).id != params[:member][:user][:role_id].to_i
      render json: {
               message: "Failed to create member role missmatch",
               params:params,
             }, status: :unprocessable_entity
    end
  end
def ensure_authorised!
   if current_user.role_id != (Role.find_by(name:"admin")).id && current_user.role_id != (Role.find_by(name:"librarian")).id
    render json: {
             status: 401,
             message: "Access denied.",
             params:params
           }, status: :unauthorized
  end
end
end
