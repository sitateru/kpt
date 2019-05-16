class User < ApplicationRecord
  before_destroy :do_not_destroy_open_issue

  # for soft delete
  acts_as_paranoid
  has_many :assignments # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :issues, through: :assignments

  validates :name, presence: true, uniqueness: { scope: :deleted_at }
  # not strictly
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  private

  def do_not_destroy_open_issue
    return unless issues.pluck(:is_closed).include?(false)

    errors[:user] << 'This user is assigned to an open issue'
    throw(:abort)
  end
end
