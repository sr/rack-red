require "helper"

class RackREDTest < Test::Unit::TestCase
  def test_last_modified
    assert get("/last_modified_win").ok?

    exception = assert_raise(Rack::RED::Error) {
      assert get("/last_modified_fail").ok?
    }
    assert_match(/If-Modified-Since/, exception.message)
  end

  def test_etag
    assert get("/etag_win").ok?

    exception = assert_raise(Rack::RED::Error) {
      assert get("/etag_fail").ok?
    }
    assert_match(/If-None-Match/, exception.message)
  end
end
