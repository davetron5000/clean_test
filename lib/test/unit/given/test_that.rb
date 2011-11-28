module Test # :nodoc:
  module Unit # :nodoc:
    module Given # :nodoc:
      # Public: Module that, when included, makes a class method, +#test_that+ available
      # to create test methods in a more fluent way.  See ClassMethods.
      module TestThat
        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods

          # Public: Create a new test method with the given optional description and
          # body.
          #
          # description - a string describing what is being tested; write this as a follow on
          #               from the phrase "test that".  If nil, a name will be constructed
          #               based on the block
          # block - the body of the test.
          #
          # Example
          #
          #     # Create a rails-style test method
          #     test_that "area is computed based on positive radius" do
          #       Given {
          #         @circle = Circle.new(10)
          #       }
          #       When {
          #         @area = @circle.area
          #       }
          #       Then {
          #         assert_equal 314,@area
          #       }
          #     end
          #
          #     # Create an "anonymous" test, where the test body
          #     # is clear enough as to what's being tested
          #     test_that {
          #       Given a_circle(:radius => 10)
          #       When get_area
          #       Then area_should_be(314)
          #     }
          def test_that(description=nil,&block)
            raise "You must provide a block" if block.nil?
            description = make_up_name(block) if description.nil?
            test_name = "test_#{description.gsub(/\s+/,'_')}".to_sym
            defined = instance_method(test_name) rescue false
            raise "#{test_name} is already defined in #{self}" if defined
            define_method(test_name, &block)
          end

          private 

          def make_up_name(some_proc)
            if some_proc.respond_to? :source_location
              name,location = some_proc.source_location
              "anonymous test at #{name}, line #{location}"
            else
              "anonymous test for proc #{some_proc.object_id}"
            end
          end
        end

      end
    end
  end
end
