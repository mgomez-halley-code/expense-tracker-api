module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      
      def create
        build_resource(sign_up_params)

        resource.save
        if resource.persisted?
          render json: {
            message: 'Signed up successfully.',
            user: resource
          }, status: :ok
        else
          render json: {
            message: 'User could not be created.',
            errors: resource.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      private

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end