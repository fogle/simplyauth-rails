module SimplyAuth
  module ControllerHelpers
    def current_session
      Thread.current[:simply_auth_session] ||= find_session
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
        redirect_to simply_auth.new_session_path
        false
      end
    end

    def find_session
      begin
        SimplyAuth::Session.find(session[:simply_auth_session_id]) if session[:simply_auth_session_id]
      rescue RestClient::NotFound
        nil
      end
    end
  end
end