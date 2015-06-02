class Question < ActiveRecord::Base
has_many :answers, :dependent :destroy

validates :title, :body, presence: true
validates_length_of :title, in: 5..140
end
