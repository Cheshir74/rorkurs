class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all

  end

  def admin_abilities
    can :manage, :all

  end

  def user_abilities
    guest_abilities
    can :manage, :profile
    can :manage, User

    alias_action :create, :read, :update, :destroy, :to => :crud
    can :crud, [Question, Answer], user: user
    can :create, Comment
    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      votable.user != user && !user.voted?(votable)
    end
    can :vote_destroy, Vote do |vote|
      vote.user == user
    end
    can :manage, Attachment do |attachment|
      user.own?(attachment.attachmentable)
    end
    can :set_best, Answer do |answer|
      user.own?(answer.question)
    end

    can :create, Subscriber do |subscriber|
      !user.subscribers.where(question_id:subscriber.question).present?
    end

  end

end
