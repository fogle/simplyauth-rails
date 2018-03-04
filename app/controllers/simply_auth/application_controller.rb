module SimplyAuth
  class ApplicationController < ::ApplicationController
    before_action do
      @simply_auth_view = true
    end
    layout "application"
  end
end
