stack = Faraday::RackBuilder.new do |builder|
  builder.response :logger
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end

Octokit.middleware = stack if Rails.env.development?
Octokit.auto_paginate = true
