class LanMailer < ActionMailer::Base
  # ActionMailer doesn't seem to have before_filters...
  # before_filter :set_settings_from_db
  #LanMailer.smtp_settings = Settings.mailinglist_smtp_settings
  #ActionMailer::Base.smtp_settings = Settings.mailinglist_smtp_settings

  def registration_confirmation(attendance)
    @attendance = attendance
    @user       = attendance.user
    mail(:to => "#{@user.name} <#{@user.email}>",
         :from => Settings.mailinglist_sender_email,
         :subject => "TEST").deliver
  end

  def general_mail(mailinglist_user, subject, message)
    @user    = mailinglist_user
    @message = message
    mail(:to => "#{@user.name} <#{@user.email}>",
         :from => Settings.mailinglist_sender_email,
         :subject => subject).deliver
  end

private

  #def set_settings_from_db
  #  smtp_settings ||= Settings.mailinglist_smtp_settings
  #end
end
