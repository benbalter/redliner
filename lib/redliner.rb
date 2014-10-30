require 'octokit'
require 'sinatra'
require 'sinatra_auth_github'
require 'dotenv'
require 'securerandom'
require 'redis'
require 'json'
require_relative "redliner/document"
require_relative "redliner/repository"

Dotenv.load

module Redliner
  class App < Sinatra::Base

    set :root, File.dirname(File.dirname(__FILE__))

    enable :sessions

    set :github_options, {
      :scopes    => "repo",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    register Sinatra::Auth::Github

    use Rack::Session::Cookie, {
      :http_only => true,
      :secret => ENV['SESSION_SECRET'] || SecureRandom.hex
    }

    configure :production do
      require 'rack-ssl-enforcer'
      use Rack::SslEnforcer
    end

    def redis
      @redis ||= Redis.new \
        :host     => redis_url.host,
        :port     => redis_url.port,
        :password => redis_url.password
    end

    def redis_url
      @redis_url ||= URI.parse(ENV["REDISTOGO_URL"] || ENV["REDIS_URL"] || "redis://localhost:16379")
    end

    def user
      env['warden'].user unless env['warden'].nil?
    end

    def guest_token
      ENV['GITHUB_TOKEN']
    end

    def token
      if user
        user.token
      else
        guest_token
      end
    end

    def client
      @client ||= Octokit::Client.new :access_token => token
    end

    def render_template(template, locals)
      halt erb template, :layout => :layout, :locals => locals.merge({ :template => template })
    end

    def cache_content(content)
      session[:content] = content
    end

    def cached_content
      session[:content]
    end

    def uncache_content
      session[:content] = nil
    end

    def pull_request_title
      name = params[:type] == "guest" ? params[:name] : user.login
      "Redline submission from #{name}"
    end

    def pull_request_body
      "COPY HERE"
    end

    get "/:owner/:repo/:view/:ref/*" do
      doc = Document.new( {
        :path => params[:splat].first.to_s,
        :repo => params[:repo],
        :owner => params[:owner],
        :ref => params[:ref],
        :app => self
      })
      doc.save!
      redirect to("/document/#{doc.uuid}"), 301
    end

    get "/document/:uuid" do
      document = Document.find_by_uuid(params[:uuid], self)
      render_template :form, { :document => document }
    end

    post "/document/:uuid" do
      document = Document.find_by_uuid(params[:uuid], self)

      # create a new branch
      client.create_ref document.repo.nwo, "heads/#{document.repo.patch_branch}", document.repo.head_sha

      # push our changes to the new branch
      client.update_contents document.repo.nwo, document.path, "TEST", document.sha, params[:content], { :branch => document.repo.patch_branch }

      # Submit the pull request
      pr = client.create_pull_request document.repo.nwo, document.repo.default_branch, document.repo.patch_branch, pull_request_title, pull_request_body

      if pr
        render_template :success, { :pull_request => pr }
      else
        render_template :error
      end
    end
  end
end
