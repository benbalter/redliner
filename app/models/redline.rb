class Redline < ActiveRecord::Base
  belongs_to :user
  belongs_to :document

  before_create :generate_key
  validates :user_id, :document_id, :key, presence: true

  private

  def generate_key
    self.key = SecureRandom.uuid
  end
end
