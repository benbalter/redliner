module Callable
  extend ActiveSupport::Concern

  included do
    attr_writer :client
  end

  def client
    @client ||= begin
      if self.respond_to?(:repository)
        repo = repository
      elsif self.class == Repository
        repo = self
      else
        repo = nil
      end
      Client.new repo: repo
    end
  end
end
