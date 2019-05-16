FactoryBot.define do
  factory :issue do
    title { "問題のタイトル" }
    body { '問題のbody' }
    status { :problem }
  end

  factory :issue_update, class: Issue do
    title { "トライに更新しました" }
    body { 'トライにbodyを更新しました' }
    status { :try }
  end
end
