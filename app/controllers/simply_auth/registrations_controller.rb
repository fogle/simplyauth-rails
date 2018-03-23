module SimplyAuth
  class RegistrationsController < ApplicationController
    before_action :load_signup_form
    def new
      @html = @step["html"].gsub("/registrations", registrations_path(form: @signup_form.id))
    end

    def index
      #handle refresh on validation error
      redirect_to new_registration_path
    end

    def after_registration(user); end

    def create
      session["simply_auth_form_submission"] ||= {}
      if (session["simply_auth_form_submission"]["id"] != @signup_form.id)
        session["simply_auth_form_submission"] = {}
      end
      session["simply_auth_form_submission"]["id"] = @signup_form.id
      session["simply_auth_form_submission"]["attributes"] ||= {}
      user_params = user_params(@step["attributes"])
      user_params.each do |k, v|
        v = v.to_h if v.respond_to?(:to_h)
        session["simply_auth_form_submission"]["attributes"][k] = v
      end
      if @step == @signup_form.steps.last
        @user = SimplyAuth::User.new(session["simply_auth_form_submission"]["attributes"])
        @user.save
        after_registration(@user)
        
        @session = SimplyAuth::Session.new(email: @user.email, password: session["simply_auth_form_submission"]["attributes"]["password"])
        @session.save
        session.delete("simply_auth_form_submission")
        session[:simply_auth_session_id] = @session.id
        redirect_to "/"
      else
        redirect_to new_registration_path(form: @signup_form.id)
      end
    end

    private

    def user_params(step_attributes)
      permissions = []
      data_attributes = []
      step_attributes.each do |attribute|
        if attribute.starts_with?("data.")
          data_attributes.push(attribute.gsub("data.", ""))
        else
          permissions << attribute
        end
      end
      if data_attributes.any?
        permissions.push(data: data_attributes)
      end
      params.require(:user).permit(permissions)
    end

    def load_signup_form
      @user_pool = SimplyAuth::UserPool.find(SimplyAuth::Config.user_pool_id)
      forms = SimplyAuth::SignupForm.all(@user_pool.application_id)
      @signup_form = params[:form] ? forms.find{|f| f.id == params[:form]} : forms.first
      session["simply_auth_form_submission"] ||= {}
      session["simply_auth_form_submission"]["attributes"] ||= {}
      session["simply_auth_form_submission"]["attributes"]["data"] ||= {}
      @step = @signup_form.steps.find do |s|
        s["attributes"].any? do |attribute|
          if attribute.starts_with?("data.")
            session["simply_auth_form_submission"]["attributes"]["data"][attribute.gsub("data.", "")].blank?
          else
            session["simply_auth_form_submission"]["attributes"][attribute].blank?
          end
        end
      end
    end
  end
end