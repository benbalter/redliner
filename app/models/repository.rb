class Repository < ActiveRecord::Base

  has_many :documents
  validates :name, :owner, presence: true

  include Callable

  def nwo=(nwo)
    parts = nwo.split("/")
    raise ArgumentError, "Must provide name with owner (e.g., benbalter/redliner)" unless parts.count == 2
    owner = parts[0]
    name  = parts[1]
  end

  def url
    "#{Octokit.web_endpoint}#{nwo}"
  end

  def nwo
    "#{owner}/#{name}"
  end

  def private?
    @private ||= client.sudo_client.repo(nwo).private?
  end

  def public?
    !private?
  end

  def branches
    @branches ||= client.pullable.branches(nwo)
  end

  def branch?(branch)
    branches.any? { |b| b.name == branch }
  end
end
