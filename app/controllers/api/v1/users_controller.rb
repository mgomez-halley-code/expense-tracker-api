module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def profile
        render json: {
          user: {
            id: current_user.id,
            email: current_user.email,
            created_at: current_user.created_at
          }
        }, status: :ok
      end
    end
  end
end