class Client

  attr_accessor :user_token
  attr_accessor :repo

  def initialize(hash={})
    @user_token = hash[:token]
    @repo       = hash[:repo]
  end

  def pushable
    pushable? ? client : sudo_client
  end

  def pullable
    pullable? ? client : sudo_client
  end

  def pushable?
    @pushable ||= permissions && permissions.push
  end

  def pullable?
    @pullable ||= permissions && permissions.pull
  end

  def client
    @client ||= _client
  end

  def sudo_client
    @sudo_client ||= _client(true)
  end

  private

  def permissions
    repo && client.repo(repo.nwo).permissions
  end

  def _client(sudo=false)
    Octokit::Client.new({
      :access_token  => sudo ? ENV["GITHUB_TOKEN"] : user_token,
      :client_id     => ENV["GITHUB_CLIENT_ID"],
      :client_secret => ENV["GITHUB_CLIENT_SECRET"]
    })
  end
end
