module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        render json: {
          message: 'Logged in successfully.',
          user: {
            id: resource.id,
            email: resource.email,
            created_at: resource.created_at
          }
        }, status: :ok
      end

      def respond_to_on_destroy
        render json: {
          message: 'Logged out successfully.'
        }, status: :ok
      end
    end
  end
end