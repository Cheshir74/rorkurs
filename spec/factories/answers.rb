FactoryGirl.define do
  sequence :body do |k|
    "MyText #{k}"
  end

  factory :answer do
    body 
  end
  factory :invalid_answer, class: Answer do
  body nil
  end

end
