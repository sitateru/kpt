class User < ApplicationRecord
  #論理削除対応
  acts_as_paranoid
  validates :name, presence: true, uniqueness: { scope: :deleted_at }
  #emailの正当性はテストメール送信等でフォローすべきなのでここでのチェックは緩めにしておく(devise準拠)
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
end
