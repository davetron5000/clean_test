require 'test/unit'
require 'clean_test/test_case'

class TestAny < Clean::Test::TestCase

  def setup
    # Fix the seed to be the same all day so our tests are repeatable
    srand((Time.now.to_i / (1000 * 60 * 60)))#.tap { |_| puts "seed: #{_}" })
  end

  test_that {
    When  { @number = any_number }
    Then  { assert_not_nil @number } 
  }

  test_that {
    When  { @number = any_number :positive }
    Then  { assert @number > 0,"We specified :positive, but got a negative" }
  }

  test_that {
    When  { @number = any_number :negative }
    Then  { assert @number < 0,"We specified :negative, but got a positive" }
  }

  test_that {
    When  { @number = any_int }
    Then  { 
      assert_not_nil @number
      assert_equal @number.to_i,@number,"Expected an int, not a #{@number.class}" 
    }
  }

  test_that {
    When  { @int = any_int :positive }
    Then  { assert @int > 0,"We specified :positive, but got a negative" }
  }

  test_that {
    When  { @int = any_int :negative }
    Then  { assert @int < 0,"We specified :negative, but got a positive" }
  }

  test_that {
    When  { @string = any_string }
    Then  { 
      assert_not_nil @string
      assert_equal String,@string.class
    }
  }

  test_that {
    When  { @string = any_string :max => 255 }
    Then  { 
      assert_equal String,@string.class
      assert @string.length <= 255,"Expected a string of less than 256 characters, got #{@string.length}" 
    }
  }

  test_that {
    When  { @string = any_string :min => 1000 }
    Then  { 
      assert_equal String,@string.class
      assert @string.length >= 1000,"Expected a string of at least 1000 characters, got one of #{@string.length} characters" 
    }
  }

  test_that "min and max must agree" do
    When {
      @code = lambda { @string = any_string :min => 10, :max => 3 }
    }
    Then {
      assert_raises(RuntimeError,&@code)
    }
  end

  [
    [-10,  1],
    [  0,  1],
    [  0,  0],
    [  0,-10],
  ].each do |(min,max)|
    test_that "both min and max must be positive (#{min},#{max})" do
      When {
        @code = lambda { @string = any_string :min => min, :max => max }
      }
      Then {
        assert_raises(RuntimeError,&@code)
      }
    end
  end

  test_that {
    When { @sentence = any_sentence }
    Then { assert @sentence.split(/\s/).size > 10,@sentence }
  }

  test_that {
    When { @sentence = any_sentence :max => 5 }
    Then { assert @sentence.split(/\s/).size <= 5,@sentence }
  }

  test_that {
    When { @sentence = any_sentence :min => 20 }
    Then { assert @sentence.split(/\s/).size >= 20,@sentence }
  }


  test_that "any_symbol works" do
    When {
      @symbol = any_symbol
    }
    Then {
      assert_not_nil @symbol
      assert @symbol.kind_of? Symbol
      assert @symbol.to_s.length < 20
    }
  end
end
