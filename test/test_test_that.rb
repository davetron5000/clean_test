require 'test/unit'
require 'clean_test/test_case'

class TestSimpleGiven < Clean::Test::TestCase


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

  $FOR_TESTING_ONLY_SKIP_STDERR = true
  skip_a_test_that "a skipped test isn't called" do
    raise "This shouldn't happen!"
  end

  someday_test_that "a pending test isn't called" do
    raise "This shouldn't happen, either!"
  end
  $FOR_TESTING_ONLY_SKIP_STDERR = false

  def test_that_test_that_barfs_with_no_block
    assert_raises RuntimeError do
      self.class.test_that "foo"
    end
  end
end
