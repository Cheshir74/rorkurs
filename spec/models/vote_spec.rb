require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :value }
  it { should belong_to :votable }
  it { should belong_to :user}
  it { should validate_uniqueness_of(:votable_id).scoped_to([:votable_type,:user_id]) }
end
