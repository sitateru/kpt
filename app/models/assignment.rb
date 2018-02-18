class Assignment < ApplicationRecord
  belongs_to :issue
  belongs_to :user
end
