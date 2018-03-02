module SimplyAuth
  class Engine < ::Rails::Engine
    isolate_namespace SimplyAuth

    initializer "controller_helpers" do
      ActiveSupport.on_load(:action_controller) do
        include SimplyAuth::ControllerHelpers
        helper_method :user_logged_in?, :current_user
        

        before_action do
          Thread.current[:simply_auth_session] = nil
        end
        after_action do
          Thread.current[:simply_auth_session] = nil
        end
      end
    end
  end
end
