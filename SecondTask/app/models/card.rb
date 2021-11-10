class Card < ApplicationRecord
  belongs_to :column
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 200 }
end
