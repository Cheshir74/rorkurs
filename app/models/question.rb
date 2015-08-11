class Question < ActiveRecord::Base
  include Votable
  include Commentable

  scope :new_questions, -> { where("created_at >= ?", Time.zone.now.beginning_of_day) }

  has_many :answers, -> { order('best DESC') }, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  belongs_to :user
  has_many :subscribers, dependent: :destroy
  validates :title, :body, :user_id, presence: true
  validates :title, length: { in: 5..140 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :calculate_reputation

  private

  def calculate_reputation
     reputation = Reputation.calculate(self)
     self.user.update(reputation: reputation)
  end


end
