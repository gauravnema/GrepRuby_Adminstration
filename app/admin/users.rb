ActiveAdmin.register User do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
  permit_params :first_name, :last_name, :email , :user_type, :gender, :dob, :mobile, :family_member_mobile, :address, :avatar
  
  index do  
    column :id
    column :first_name
    column :last_name
    column :gender
    column :dob
    column :mobile
    column :family_member_mobile
    column :email
    column :address
    column :user_type
    column :avatar
    actions
  end 
  
  form do |f|
    f.inputs "Create User" do
      f.input :first_name
      f.input :last_name
      f.input :gender
      f.input :dob , :as => :datepicker
      f.input :mobile
      f.input :family_member_mobile
      f.input :address
      f.input :user_type
      f.input :avatar, :as => :file
      end
    f.actions
  end
  
  action_item do
    link_to 'Invite New User', new_invitation_admin_users_path
  end
 
  collection_action :new_invitation do
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    
  end
  
  def create                        #perform task
    @user=User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end  
  
  def index
    @user = User.all
 
  end

  def update
    @user = User.find(params[:id])
    @user.update_without_password(permitted_params[:user])
    if @user.errors.blank?
      redirect_to admin_users_path, :notice => "User updated successfully."
    else
      render :edit
    end
  end
 
  collection_action :send_invitation, :method => :post do
   
    @user = User.invite!(params.require(:user).permit(:first_name, :last_name, :email , :user_type,:invitation_token))
    if @user.errors.empty?
      flash[:success] = "User has been successfully invited."
      redirect_to admin_root_path
    else
      messages = @user.errors.full_messages.map { |msg| msg }.join
      flash[:error] = "Error: " + messages
      redirect_to admin_root_path
    end
  end
  
  filter :first_name
  filter :last_name
  filter :gender
  filter :dob
  filter :mobile
  filter :family_member_mobile
  filter :email
  filter :address
  filter :user_type
  
  
end
