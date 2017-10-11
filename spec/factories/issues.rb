FactoryGirl.define do
  factory :issue do
    title "問題のタイトル"
    body '問題のbody'
    status :problem
  end
end
