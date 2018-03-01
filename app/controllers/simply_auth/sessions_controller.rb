module SimplyAuth
  class SessionsController < ApplicationController
    def new
      @session = SimplyAuth::Session.new
    end

    def create
      @session = SimplyAuth::Session.new(session_params)
      if @session.save
        session[:simply_auth_session_id] = @session.id
        redirect_to :root
      else
        render :new
      end
    end

    def destroy
      current_session.destroy
      session.destroy
      redirect_to :root
    end

    private

    def session_params
      params.require(:simply_auth_session).permit(:email, :password)
    end
  end
end