# Rails.application.config.action_mailer.smtp_settings = {
#     address: "smtp.yandex.ru",
#     port: 25,
#     domain: 'anti-pms.com',
#     enable_starttls_auto: true,
#     authentication: 'login',
#     user_name: 'no-reply@anti-pms.com',
#     password: '79161716460'
# }
Rails.application.config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'anti-pms.ru',
    user_name:            'no-reply@anti-pms.ru',
    password:             '79161716460',
    authentication:       'plain',
    enable_starttls_auto: true  }

