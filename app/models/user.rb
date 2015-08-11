class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable,  omniauth_providers: [:vkontakte,:facebook,:twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations
  has_many :subscribers, dependent: :destroy
  accepts_nested_attributes_for :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.try(:email)

    if email
      user = User.where(email: email).first
    else
      return nil
    end

    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = generate_user(email)
      user.skip_confirmation!
      user.save!
      user.create_authorization(auth)
    end
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def own?(object)
    id == object.user_id
  end

  def voted?(votable)
    votes.where(votable: votable).first ? true : false
  end

  private

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    user = User.new(email: email, password: password, password_confirmation: password)
    user
  end
end
