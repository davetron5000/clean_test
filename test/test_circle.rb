require 'test/unit/given'

class Circle
  def initialize(radius)
    @radius = radius
  end

  def area; (3.14 * @radius * @radius).to_i; end
end

class TestCircle < Test::Unit::Given::TestCase
  test_that {
    Given { @circle = Circle.new(10) }
    When  { @area = @circle.area     }
    Then  { assert_equal 314,@area   }
  }
end
