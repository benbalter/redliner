class Document < ActiveRecord::Base
  belongs_to :repository
  has_many   :redlines

  validates :repository_id, :path, presence: true
end
