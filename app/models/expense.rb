class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :category, presence: true
end
