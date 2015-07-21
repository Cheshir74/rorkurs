class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value,  presence: true
  validates :votable_id, presence: true, uniqueness: { scope: [:votable_type, :user_id] }

end
