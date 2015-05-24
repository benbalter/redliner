class Redline < ActiveRecord::Base
  belongs_to :user
  belongs_to :document

  before_validation :generate_key
  validates :user_id, :document_id, :key, presence: true

  include Callable

  extend FriendlyId
  friendly_id :key

  def repository
    document.repository
  end

  def pull_request
    @pull_request ||= PullRequest.new(self)
  end

  def submit!(hash)
    branch!
    push!(hash[:contents], hash[:commit_msg])
    pull_request.submit!
  end

  # Name of branch to submit pull request from
  # Starts with patch-1 and keeps going until it finds one not taken
  def patch_branch
    @patch_branch ||= begin
      num = 1
      branch = "patch-#{num}"
      while document.repository.branch?(branch) do
        num = num + 1
        branch = "patch-#{num}"
      end
      branch
    end
  end

  private

  def generate_key
    self.key = SecureRandom.uuid if self.key.blank?
  end

  def branch!
    client.pushable.create_ref repository.nwo, "heads/#{patch_branch}", document.base_sha
  end

  def push!(contents, commit_msg)
    client.pushable.update_contents repository.nwo, document.path, commit_msg, document.sha, contents, { :branch => patch_branch }
  end
end
