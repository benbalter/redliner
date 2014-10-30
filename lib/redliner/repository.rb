module Redliner
  class Repository
    attr_accessor :nwo

    def initialize(nwo, app)
      @nwo = nwo
      @app = app
    end

    def owner
      nwo.split("/").first
    end

    def name
      nwo.split("/").last
    end

    def public?
      false
    end

    def head_sha
      @app.client.ref(nwo, "heads/#{default_branch}").object.sha
    end

    def meta
      @meta ||= @app.client.repo(nwo)
    end

    def default_branch
      @deault_branch ||= meta["default_branch"]
    end

    def branches
      @branches ||= @app.client.branches(nwo)
    end

    def patch_branch
      @patch_branch ||= begin
        num = 0
        while branches.any? { |b| b.name == "patch-#{num}" } do
          num = num + 1
          branch = "patch-#{num}"
        end
        branch
      end
    end

    def to_h
      {
        :owner => owner,
        :name => name,
        :nwo => nwo,
        :public => public?
      }
    end
  end
end
