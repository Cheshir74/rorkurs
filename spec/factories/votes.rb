FactoryGirl.define do
  factory :vote_up do
    vote '1'
  end

  factory :vote_down, class: 'Vote' do
    vote '-1'
  end

end
