require 'rails_helper'

RSpec.describe Expense, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:category) }

  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:category) }
end
