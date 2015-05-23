unless ENV["GITHUB_CLIENT_ID"] && ENV["GITHUB_CLIENT_SECRET"]
  abort "The GITHUB_KEY and GITHUB_SECRET environment variables aren't set."
end

Devise.setup do |config|
  require 'devise/orm/active_record'

  config.authentication_keys   = [ :login ]
  config.case_insensitive_keys = [ :login ]
  config.strip_whitespace_keys = [ :login ]
  config.stretches = Rails.env.test? ? 1 : 10
  config.expire_all_remember_me_on_sign_out = true
  config.extend_remember_period = false
  config.omniauth :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: 'user,public_repo'
end
