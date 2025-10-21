require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:user) { create(:user) }  # create a valid user first
  subject { create(:category, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:expenses).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
  end
end
