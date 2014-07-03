ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true


ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "gmail.com",
    :user_name            => "support@dropandgoauto.com",
    :password             => "XXXXXXX",
    :authentication       => "plain",
    :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = ENV["ROOT_URL"] || "localhost:3000"