class Users::InvitationsController < Devise::InvitationsController
 
  respond_to :html, :js
  
  def edit
    render :edit, :layout => false
  end
 
  # PUT /resource/invitation
  def update
    self.resource = resource_class.accept_invitation!(user_param)
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message :notice, flash_message
      sign_in(resource_name, resource)
 
      redirect_to edit_user_registration_path#, :alert => "Welcome! Please fill out your profile and upload a headshot." 
    else
       respond_with_navigational(resource){ render :edit, :layout => false }
    end
  end
  
  def new
   @user = User.new
  end
  
  def show
    @user=User.find(params[:id])
  end
  
 def create
    @user=User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
  
 
 
private

  def user_param
     params.require(:user).permit(:email, :password, :password_confirmation, :invitation_token )
  end

  # should return an instance of resource class
  def invite_resource
    ## skip sending emails on invite
    resource_class.invite!(invite_params, current_inviter) do |u|
      u.skip_invitation = true
    end
  end

  # this is called when accepting invitation
  # should return an instance of resource class
  def accept_resource
    resource = resource_class.accept_invitation!(update_resource_params)
    ## Report accepting invitation to analytics
    Analytics.report('invite.accept', resource.id)
    resource
  end
end
