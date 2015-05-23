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
end
