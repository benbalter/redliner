module Redliner
  class Document

    attr_accessor :repo
    attr_accessor :path
    attr_accessor :ref

    def initialize(options)
      @path = options[:path]
      @ref = options[:ref]
      @repo = Repository.new "#{options[:owner]}/#{options[:repo]}", options[:app]
      @app = options[:app]
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    # Save to Redis backend
    def save!
      @app.redis.set uuid, to_h.to_json
    end

    def to_h
      {
        :repo => repo.to_h,
        :ref => ref,
        :path => path
      }
    end

    def blob
      @blob ||= @app.client.contents(repo.nwo, :path => path, :ref => ref)
    end

    def sha
      blob.sha if blob
    end

    def contents
      @contents ||= Base64.decode64(blob.content).force_encoding("utf-8") if blob
    end
    alias_method :content, :contents

    def self.find_by_uuid(uuid, app)
      doc = JSON.parse(app.redis.get(uuid))
      self.new({
        :path => doc["path"],
        :ref => doc["ref"],
        :owner => doc["repo"]["owner"],
        :repo => doc["repo"]["name"],
        :app => app
      }) if doc
    end
  end
end
