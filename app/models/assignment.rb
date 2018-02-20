class Assignment < ApplicationRecord
  belongs_to :issue, -> { with_deleted }
  belongs_to :user, -> { with_deleted }

  validates :issue_id, uniqueness: { scope: :user_id }
  validate :user_must_exists, :issue_must_exists

  private

  def user_must_exists
    errors.add(:user_id, 'must exists') if user.nil? || user.deleted?
  end

  def issue_must_exists
    errors.add(:issue_id, 'must exists') if issue.nil? || issue.deleted?
  end
end
