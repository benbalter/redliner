module Redliner
  class Repository
    attr_accessor :nwo

    def initialize(nwo, app, ref = nil)
      @nwo = nwo
      @app = app
      @ref = ref
    end

    def owner
      nwo.split("/").first
    end

    def name
      nwo.split("/").last
    end

    def private?
      meta['private']
    end

    def base_sha
      ref = @ref || default_branch
      @app.client.ref(nwo, "heads/#{ref}").object.sha
    end

    # Cached response from repository API
    def meta
      @meta ||= @app.client.repo(nwo)
    end

    def default_branch
      @deault_branch ||= meta["default_branch"]
    end

    # Returns array of Octokit branch objects
    def branches
      @branches ||= @app.client.branches(nwo)
    end

    # Name of branch to submit pull request from
    # Starts with patch-0 and keeps going until it finds one not taken
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
