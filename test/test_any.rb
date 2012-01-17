require 'test/unit'
require 'clean_test/test_case'

class TestAny < Clean::Test::TestCase
  test_that {
    Given { random_seeded_for_negative_float }
    When  { @number = any_number }
    Then { 
      assert @number < 0,"any_number should be negative, but we got #{@number}" 
      assert @number.to_i != @number,"Expected a float"
    }
  }
  test_that {
    Given { random_seeded_for_positive }
    When  { @number = any_number }
    Then  { assert @number > 0,"any_number should be positive, but we got #{@number}" }
  }

  test_that {
    Given { random_seeded_for_negative_float }
    When  { @number = any_number :positive }
    Then  { assert @number > 0,"We specified :positive, but got a negative" }
  }

  test_that {
    Given { random_seeded_for_positive }
    When  { @number = any_number :negative }
    Then  { assert @number < 0,"We specified :negative, but got a positive" }
  }

  test_that {
    Given { random_seeded_for_negative_float }
    When  { @number = any_int }
    Then  { 
      assert @number < 0,"Expected int to be negative"
      assert_equal @number.to_i,@number,"Expected an int, not a #{@number.class}" 
    }
  }

  test_that {
    Given { random_seeded_for_negative_float }
    When  { @int = any_int :positive }
    Then  { assert @int > 0,"We specified :positive, but got a negative" }
  }

  test_that {
    Given { random_seeded_for_positive }
    When  { @int = any_int :negative }
    Then  { assert @int < 0,"We specified :negative, but got a positive" }
  }

  test_that {
    Given { random_seeded_for_long_string }
    When  { @string = any_string }
    Then  { 
      assert @string.length < 1441,"expected less than our rand value, but got #{@string.length}" 
      assert_equal String,@string.class
    }
  }

  test_that {
    Given { random_seeded_for_long_string }
    When  { @string = any_string :max => 255 }
    Then  { 
      assert @string.length <= 255,"Expected a string of less than 256 characters, got #{@string.length}" 
      assert_equal String,@string.class
    }
  }

  test_that {
    Given { random_seeded_for_long_string }
    When  { @string = any_string :min => 1000 }
    Then  { 
      assert @string.length > 1000,"Expected a string of at least 1500 characters, got one of #{@string.length} characters" 
      assert_equal String,@string.class
    }
  }

  test_that "we can register custom anys" do 
    Given {
      new_any :foo do
        "bar"
      end
    }
    When {
      @result = any :foo
    }
    Then {
      assert_equal 'bar',@result
    }
  end

  test_that "custom anys can take options" do 
    Given {
      new_any :foo do |options|
        if options[:baaz]
          'quux'
        else
          'bar'
        end
      end
    }
    When {
      @result = any :foo, :baaz => true
    }
    Then {
      assert_equal 'quux',@result
    }
  end

  [String,[Integer,Fixnum],Fixnum,Float,[Numeric,Float]].each do |klass|
    test_that "can get an any #{klass}" do 
      Given {
        @class = @expected_class = klass
        if @class.kind_of? Array
          @expected_class = @class[1]
          @class = @class[0]
        end
      }
      When {
        @value = any @class
      }
      Then {
        assert_not_nil @value
        assert_equal @expected_class,@value.class
      }
    end
  end

  private

  def random_seeded_for_long_string
    Random.srand(34)
  end

  def random_seeded_for_negative_float
    Random.srand(45)
  end

  def random_seeded_for_positive
    Random.srand(2)
  end

end
