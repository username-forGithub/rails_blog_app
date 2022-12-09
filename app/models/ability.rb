class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.is?(:admin)
      can :manage, :all
    else
      can :destroy, Post, author: user
      can :destroy, Comment, author: user
      can :read, :all # user(not admin) can read all the blogs
    end
  end
end
