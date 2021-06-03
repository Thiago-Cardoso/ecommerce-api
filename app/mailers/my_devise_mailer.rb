class MyDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"

  def reset_password_instructions(record, token, opts = {})
      attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
      super
  end
end