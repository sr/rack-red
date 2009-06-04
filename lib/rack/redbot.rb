module Rack
  class RED
    class Error < StandardError; end

    module Assertion
      def assert(message, &block)
        raise(Error, message) unless block.call
      end
    end

    include Assertion

    def initialize(app)
      @app = app
    end

    def call(env)
      headers = @app.call(env)[1]

      if last_modified = headers["Last-Modified"]
        assert("If-Modified-Since conditional requests are not supported") {
          res = @app.call(env.merge("HTTP_IF_MODIFIED_SINCE" => last_modified))
          res.first == 304
        }
      end

      if etag = headers["ETag"]
        assert("If-None-Match conditional requests are not supported") {
          res = @app.call(env.merge("HTTP_IF_NONE_MATCH" => etag))
          res.first == 304
        }
      end

      @app.call(env)
    end
  end
end
