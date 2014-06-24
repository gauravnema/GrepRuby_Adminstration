class Ability
  include CanCan::Ability

  def initialize(user)
   
    user ||= User.new 
    
    can :manage, :all if user.user_type == "admin"
    can :manage, :update if user.user_type == "user"
  end
 
end
  
