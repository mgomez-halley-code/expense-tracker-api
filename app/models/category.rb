class Category < ApplicationRecord
  belongs_to :user
  # TODO:
  # has_many :expenses, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :user_id }
end
