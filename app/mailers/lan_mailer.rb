class LanMailer < ActionMailer::Base
  # ActionMailer doesn't seem to have before_filters...
  # before_filter :set_settings_from_db
  default from: Settings.mailinglist_sender_email


  def registration_confirmation(attendance)
    set_settings_from_db

    @attendance = attendance
    @user       = attendance.user
    mail(:to => "#{@user.name} <#{@user.email}>", :subject => "TEST").deliver
  end

private

  def set_settings_from_db
    smtp_settings ||= Settings.mailinglist_smtp_settings
  end
end
