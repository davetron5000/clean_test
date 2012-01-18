require 'test/unit'
require 'clean_test/given_when_then'
require 'clean_test/any'
require 'clean_test/test_that'

module Clean #:nodoc:
  module Test #:nodoc:
    # Public: A Base class brings in all modules that are part
    # of Clean::Test.
    #
    # Example
    #
    #     class TestCircle < Clean::Test::TestCase
    #       test_that {
    #         Given { @circle = Circle.new(10) }
    #         When  { @area = @circle.area }
    #         Then  { assert_equal 314,@area }
    #       }
    #     end
    class TestCase < ::Test::Unit::TestCase
      include GivenWhenThen
      include TestThat
      include Any
      if RUBY_VERSION =~ /^1\.8\./
        # Avoid the stupid behavior of 
        # complaining that no tests were specified for 1.8.-like rubies
        def default_test
        end
      end
    end
  end
end
