class PullRequest

  attr_reader :redline
  include Callable

  def initialize(redline)
    @redline = redline
    @client = redline.client
    redline.document.client = redline.client
    redline.document.repository.client = redline.client
  end

  def title
    "Redline submission from #{redline.user.name}"
  end

  def body
    body = "This pull request was generated by [Redliner](https://github.com/benbalter/redliner/).\n"
    body += "Submitted on behalf of #{redline.user.name}"
    body += " from #{request.remote_ip} using #{request.user_agent}" unless redline.user
    body += "."
    body
  end

  def submit!
    response = client.pullable.create_pull_request redline.document.repository.nwo,
      redline.document.ref,
      redline.patch_branch,
      title,
      body
    response.number if response
  end

end