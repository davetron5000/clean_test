require 'test/unit'
require 'clean_test/test_case'

class TestGivenWhenThen < Clean::Test::TestCase

  def test_basics
    Given {
      @x = nil
    }
    And {
      @y = nil
      @z = 10
    }
    When {
      @x = 4
    }
    And {
      @y = 10
    }
    But {
      @z # not assigned
    }
    Then {
      assert_equal 4,@x
    }
    And {
      assert_equal 10,@y
    }
    But {
      assert_equal 10,@z
    }
  end

  def test_mock_support
    Given { @x = 4 }
    When the_test_runs
    Then { }
    Given { @y = 4 }
    When { @y = 10 }
    Then { assert_equal 10,@y }
    And mocks_shouldve_been_called
  end

  def test_cannot_use_locals
    Given {
      @x = nil
    }
    When {
      x = 4
    }
    Then {
      assert_nil @x
      refute defined? x
    }
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

  def test_methods_that_return_blocks
    Given a_nil_x
    When {
      @x = 4
    }
    Then {
      assert_equal 4,@x
    }
  end

  def test_can_use_symbols_for_methods
    Given :a_string
    Then {
      assert_equal "foo",@string
    }
  end

  def test_can_pass_params_to_symbols
    Given :a_string, 4
    Then {
      assert_equal 4,@string.length
    }
  end

  def test_invert_for_block_based_asserts
    Given a_nil_x
    Then {
      assert_raises NoMethodError do
        When {
          @x + 4
        }
      end
    }
  end

  private 

  def a_string(length=3)
    if length == 3
      @string = "foo"
    else
      @string = "quux"
    end
  end

  def a_nil_x
    Proc.new { @x = nil }
  end

  def refute(bool_expr)
    assert !bool_expr
  end
end
