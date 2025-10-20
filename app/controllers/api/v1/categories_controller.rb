# app/controllers/api/v1/categories_controller.rb
class Api::V1::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:update, :destroy, :show]

  def index
    categories = current_user.categories
    render json: categories, status: :ok
  end

  def show
    render json: @category, status: :ok
  end

  def create
    category = current_user.categories.new(category_params)
    if category.save
      render json: category, status: :created
    else
      render json: { errors: category.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: { errors: @category.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def set_category
    @category = current_user.categories.find_by(id: params[:id])
    return render json: { error: 'Not Found' }, status: :not_found unless @category
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
