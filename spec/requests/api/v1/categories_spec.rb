require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }
  let!(:categories) { create_list(:category, 3, user: user) }

  describe "GET /index" do
    it "returns all categories for the current user" do
      get '/api/v1/categories', headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /show" do
    let(:category) { categories.first }

    it "returns the category for the current user" do
      get "/api/v1/categories/#{category.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(category.id)
      expect(json['name']).to eq(category.name)
    end

    it "returns not_found for another user's category" do
      other_user = create(:user)
      other_category = create(:category, user: other_user, name: "Other")

      get "/api/v1/categories/#{other_category.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    it "creates a new category for the current user" do
      category_params = { category: { name: 'Transport' } }

      post '/api/v1/categories', params: category_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('Transport')
      expect(Category.last.user).to eq(user)
    end

    it "returns an error if name is missing" do
      category_params = { category: { name: '' } }

      post '/api/v1/categories', params: category_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']['name']).to include("can't be blank")
    end
  end

  describe "PUT /update" do
    let(:category) { categories.first }

    it "updates the category name for the current user" do
      category_params = { category: { name: 'New Name' } }

      put "/api/v1/categories/#{category.id}", params: category_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('New Name')
      expect(category.reload.name).to eq('New Name')
    end

    it "returns an error if the name is blank" do
      category_params = { category: { name: '' } }

      put "/api/v1/categories/#{category.id}", params: category_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']['name']).to include("can't be blank")
    end

    it "does not allow updating another user's category" do
      other_user = create(:user)
      other_category = create(:category, user: other_user, name: 'Other')
      category_params = { category: { name: 'Hacked' } }

      put "/api/v1/categories/#{other_category.id}", params: category_params, headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /destroy" do
    let(:category) { categories.first }

    it "deletes the category for the current user" do
      expect {
        delete "/api/v1/categories/#{category.id}", headers: auth_headers_for(user)
      }.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "does not allow deleting another user's category" do
      other_user = create(:user)
      other_category = create(:category, user: other_user, name: 'Other')

      delete "/api/v1/categories/#{other_category.id}", headers: auth_headers_for(user)

      expect(response).to have_http_status(:not_found)
      expect(Category.exists?(other_category.id)).to be true
    end
  end
end
