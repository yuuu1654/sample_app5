class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@example.com' #慣習
  layout 'mailer'
end
