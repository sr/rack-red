require "test/unit"
require "rack/test"
require "sinatra/base"

require "rack/red"

begin
  require "redgreen"
rescue LoadError
end

class App < Sinatra::Base
  TIME = Time.mktime(2009, 06, 04)
  ETAG = "foobarbaz"

  get "/last_modified_win" do
    last_modified(TIME)
    "miss"
  end

  get "/last_modified_fail" do
    response["Last-Modified"] = TIME.httpdate
    "miss"
  end

  get "/etag_win" do
    etag(ETAG)
    "miss"
  end

  get "/etag_fail" do
    response["ETag"] = '"%s"' % ETAG
    "miss"
  end
end

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    @app ||= Rack::Builder.new {
      use Rack::RED
      use Rack::Lint
      run App
    }
  end
end
