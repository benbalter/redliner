module Redliner
  class << self
    def client
      @client ||= Octokit::Client.new({
        :access_token  => defined?(Rails::Console) ? ENV["GITHUB_TOKEN"] : session[:token],
        :client_id     => ENV["GITHUB_CLIENT_ID"],
        :client_secret => ENV["GITHUB_CLIENT_SECRET"]
      })
    end

    def sudo_client

    end
  end
end
