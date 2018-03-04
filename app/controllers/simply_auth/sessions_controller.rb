module SimplyAuth
  class SessionsController < ApplicationController
    def new
      @session = SimplyAuth::Session.new(permit_session_params)
    end

    def show
      #handle refreshing on validation error
      redirect_to new_session_path
    end

    def create
      @session = SimplyAuth::Session.new(session_params)
      if @session.save
        session[:simply_auth_session_id] = @session.id
        redirect_to "/"
      else
        render :new
      end
    end

    def destroy
      current_session.destroy
      session.destroy
      redirect_to "/"
    end

    private

    def session_params
      params.require(:session).permit(:email, :password)
    end

    def permit_session_params
      params.permit(:session => [:email, :password])[:session]
    end
  end
end