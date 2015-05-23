class Repository < ActiveRecord::Base

  has_many :documents
  validates :name, :owner, presence: true

  def nwo=(nwo)
    parts = nwo.split("/")
    raise ArgumentError, "Must provide name with owner (e.g., benbalter/redliner)" unless parts.count == 2
    owner = parts[0]
    name  = parts[1]
  end

  def nwo
    "#{owner}/#{name}"
  end

  def private?
    !!meta['private']
  end

  def public?
    !private?
  end

  def branches
    @branches ||= Redliner.client.branches(nwo)
  end

  def branch?(branch)
    branches.any? { |b| b.name == branch }
  end
  
  # Name of branch to submit pull request from
  # Starts with patch-1 and keeps going until it finds one not taken
  def patch_branch
    @patch_branch ||= begin
      num = 1
      branch = "patch-#{num}"
      while branch?(branch) do
        num = num + 1
        branch = "patch-#{num}"
      end
      branch
    end
  end

  private
  def meta
    @meta ||= Redliner.client.repo(nwo)
  end
end
