require 'net/http'
require 'thread'
require 'timeout'

module Zazo
  module Tools
    class Logger

      class Http
        attr_reader :uri, :auth, :timeout

        def initialize(host, port, auth: nil, timeout: 10)
          @uri = build_uri(host, port)
          @auth = auth
          @timeout = timeout
        end

        def perform_async(data)
          wrap_thread_timeout do
            Net::HTTP.start(uri.hostname, uri.port) do |http|
              http.request(build_request(data))
            end
          end
        end

        private

        def build_uri(host, port)
          URI("http://#{host}:#{port}")
        end

        def build_request(data)
          request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
          request.basic_auth(auth[:username], auth[:password]) if auth
          request.body = data.to_json
          request
        end

        def wrap_thread_timeout
          Thread.new do
            begin
              Timeout::timeout(timeout) { yield }
            rescue Timeout::Error
              false
            end
          end
        end
      end

    end
  end
end
