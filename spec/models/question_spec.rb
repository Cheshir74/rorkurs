require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attachments }
  it { should have_many(:answers).dependent(:destroy).order('best DESC') }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(140) }

  it { should accept_nested_attributes_for :attachments }
end
