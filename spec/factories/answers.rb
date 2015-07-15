FactoryGirl.define do
  sequence :body do |k|
    "MyText #{k}"
  end

  factory :answer do
    body
    user
    question
    best 'false'
  end

  factory :best_answer, class: Answer do
    body
    user
    question
    best 'true'
  end

  factory :invalid_answer, class: Answer do
    body nil
    question
  end

end
