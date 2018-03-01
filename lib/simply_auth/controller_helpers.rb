module SimplyAuth
  module ControllerHelpers
    def current_session
      SimplyAuth::Session.find(session[:simply_auth_session_id]) if session[:simply_auth_session_id]
    end

    def user_logged_in?
      current_session.present?
    end

    def current_user
      current_session.try(:user)
    end

    def authenticate_user!
      if user_logged_in?
        true
      else
        redirect_to new_session_path
        false
      end
    end
  end
end