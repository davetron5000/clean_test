require 'test/unit'
require 'test_unit_given/strict'

class TestStrictGiven < Test::Unit::TestCase
  include TestUnitGiven::Strict

  def test_wrong_order_then_first
    assert_raises RuntimeError do
      Then {
        @x = 4
      }
    end
  end

  def test_basics
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

  def test_wrong_order
    assert_raises RuntimeError do
      When {
        @x = 4
      }
    end
  end

  def test_can_reuse_blocks
    invocations = 0
    x_is_nil = Given {
      @x = nil
      invocations += 1
    }
    x_is_assigned_to_four = When {
      @x = 4
      invocations += 1
    }
    x_should_be_four = Then {
      assert_equal 4,@x
      invocations += 1
    }
    Given x_is_nil
    When x_is_assigned_to_four
    Then x_should_be_four
    assert_equal 6,invocations
  end
end
