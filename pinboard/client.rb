require 'httparty'

module Pinboard
  class Client
    include HTTParty
    base_uri 'api.pinboard.in:443/v1'
    attr_accessor :api_token
    PB_AUTH_FILE = "#{ENV['HOME']}/.pb-auth"

    def initialize(options={})
      if options[:api_token]
        @api_token = options[:api_token]
      else
        @auth = { :username => options[:username],
                  :password => options[:password] }
        options = {}
        options[:basic_auth] = @auth
        @api_token = @auth[:username]+":"+self.class.get('/user/api_token', options)['result']
        self.save_api_token
      end
    end

    def save_api_token()
      if !File.exist?(PB_AUTH_FILE)
        config_file = File.new(PB_AUTH_FILE, "w")
        config_file.puts(api_token)
        config_file.close()
      end
    end

    def all_posts(params={})
      options = {}
      params = params.merge(:auth_token => api_token)
      options[:query] = params
      posts = self.class.get('/posts/all', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] if posts.class != Array
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

    def recent_posts(params={})
      options = {}
      params = params.merge(:auth_token => api_token)
      options[:query] = params
      puts options
      posts = self.class.get('/posts/recent', options)['posts']['post']
      posts = [] if posts.nil?
      posts = [posts] if posts.class != Array
      posts.map { |p| Post.new(Util.symbolize_keys(p)) }
    end

  end
end