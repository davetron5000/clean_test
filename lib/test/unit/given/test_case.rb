require 'test/unit'
require 'test/unit/given/given_when_then'
require 'test/unit/given/any'
require 'test/unit/given/test_that'

module Test # :nodoc:
  module Unit # :nodoc:
    module Given # :nodoc:
      # Public: A Base class brings in all modules that are part
      # of Test::Unit Given.
      #
      # Example
      #
      #     class TestCircle < Test::Unit::Given::TestCase
      #       test_that {
      #         Given { @circle = Circle.new(10) }
      #         When  { @area = @circle.area }
      #         Then  { assert_equal 314,@area }
      #       }
      #     end
      class TestCase < Test::Unit::TestCase
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
end
