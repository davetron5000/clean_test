require 'test/unit'
require 'test/unit/given'

class TestSimpleGiven < Test::Unit::Given::TestCase

  test_that "when assigning @x to 4, it is 4" do
    Given {
      @x = nil
    }
    When {
      @x = 4
    }
    Then {
      assert_equal 4,@x
    }
  end

  test_that {
    Given {
      @x = nil
    }
    When {
      @x = 4
    }
    Then {
      assert_equal 4,@x
    }
  }

  def test_that_test_that_barfs_with_no_block
    assert_raises RuntimeError do
      self.class.test_that "foo"
    end
  end
end
