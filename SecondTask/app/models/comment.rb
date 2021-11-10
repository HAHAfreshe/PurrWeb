class Comment < ApplicationRecord
  belongs_to :card

  validates :commenter, presence: true
  validates :body, presence: true, length: { maximum: 254 }
end
