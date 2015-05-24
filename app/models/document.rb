class Document < ActiveRecord::Base
  belongs_to :repository
  has_many   :redlines

  validates :repository_id, :path, :ref, presence: true
  validate  :valid_ref

  include Callable

  def blob
    @blob ||= client.pullable.contents(repository.nwo, :path => path, :ref => ref)
  end

  def sha
    blob.sha if blob
  end

  def base_sha
    @base_sha ||= client.pullable.ref(repository.nwo, "heads/#{ref}").object.sha
  end

  def contents
    Base64.decode64(blob.content).force_encoding("utf-8") if blob
  end

  private

  def valid_ref
    errors.add(:ref, "must be a valid ref") unless repository.branch?(ref)
  end
end
