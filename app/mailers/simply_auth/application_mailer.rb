module SimplyAuth
  class ApplicationMailer < ActionMailer::Base
    layout 'mailer'
    default from: ::ApplicationMailer.default[:from]
  end
end
