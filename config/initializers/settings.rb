Settings.defaults[:current_lan] = nil
Settings.defaults[:mailinglist_sender_email] = 'EMAIL ADDRESS'
Settings.defaults[:mailinglist_smtp_settings] = {
    :address      => "smtp.gmx.ch",
    :port         => 587,
    :user_name    => 'USERNAME',
    :password     => 'PASSWORD',
    :authentication => 'plain',
    :enable_starttls_auto => true,
    :openssl_verify_mode => 'none' }
