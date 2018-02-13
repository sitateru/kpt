class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  #emailの正当性はテストメール送信等でフォローすべきなのでここでのチェックは緩めにしておく(devise準拠)
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
end
