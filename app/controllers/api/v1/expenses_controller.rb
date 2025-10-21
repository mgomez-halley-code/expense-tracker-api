class Api::V1::ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: [:show, :update, :destroy]

  def index
    expenses = current_user.expenses.includes(:category)
    render json: expenses, status: :ok
  end

  def show
    render json: @expense, status: :ok
  end

  def create
    expense = current_user.expenses.build(expense_params)
    if expense.save
      render json: expense, status: :created
    else
      render json: expense.errors, status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense, status: :ok
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head :no_content
  end

  private

  def set_expense
    @expense = current_user.expenses.find_by(id: params[:id])
    return render json: { error: "Expense not found" }, status: :not_found unless @expense
  end

  def expense_params
    params.require(:expense).permit(:amount, :category_id, :date, :note)
  end
end
