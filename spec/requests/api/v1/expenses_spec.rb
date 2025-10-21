require 'rails_helper'

RSpec.describe "Expenses API", type: :request do
  let(:user) { create(:user) }
  let!(:category) { create(:category, user: user) }
  let!(:expenses) { create_list(:expense, 3, user: user, category: category) }

  describe "GET /index" do
    it "returns all expenses for the current user" do
      create(:expense, user: user, category: category)
      get "/api/v1/expenses", headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end
  end

  describe "GET /show" do
    let(:expense) { expenses.first }

    it "returns a specific expense for the current user" do
      get "/api/v1/expenses/#{expense.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(expense.id)
      expect(json["amount"].to_f).to eq(expense.amount)
    end

    it "returns not_found if expense belongs to another user" do
      other_user = create(:user)
      other_expense = create(:expense, user: other_user, category: create(:category, user: other_user))

      get "/api/v1/expenses/#{other_expense.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    it "creates a new expense" do
      expense_params = {
        expense: {
          amount: 20.5,
          category_id: category.id,
          date: Date.today,
          note: "Lunch"
        }
      }

      post "/api/v1/expenses", params: expense_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["note"]).to eq("Lunch")
    end

    it "returns error if amount is missing" do
      expense_params = { expense: { amount: nil, category_id: category.id, date: Date.today } }

      post "/api/v1/expenses", params: expense_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["amount"]).to include("can't be blank")
    end
  end

  describe "PUT /update" do
    let(:expense) { expenses.first }

    it "updates an expense for the current user" do
      expense_params = { expense: { note: "Updated Expense", amount: 99.99 } }

      put "/api/v1/expenses/#{expense.id}", params: expense_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["note"]).to eq("Updated Expense")
      expect(json["amount"].to_f).to eq(99.99)
      expect(expense.reload.note).to eq("Updated Expense")
    end

    it "returns unprocessable_entity if data is invalid" do
      expense_params = { expense: { amount: nil } }

      put "/api/v1/expenses/#{expense.id}", params: expense_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns not_found if expense belongs to another user" do
      other_user = create(:user)
      other_expense = create(:expense, user: other_user, category: create(:category, user: other_user))
      expense_params = { expense: { amount: 100 } }

      put "/api/v1/expenses/#{other_expense.id}", params: expense_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /destroy" do
    let(:expense) { expenses.first }

    it "deletes an expense for the current user" do
      delete "/api/v1/expenses/#{expense.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:no_content)
      expect(Expense.exists?(expense.id)).to be_falsey
    end

    it "returns not_found if expense belongs to another user" do
      other_user = create(:user)
      other_expense = create(:expense, user: other_user, category: create(:category, user: other_user))

      delete "/api/v1/expenses/#{other_expense.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end
end
