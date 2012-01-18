module Clean #:nodoc:
  module Test #:nodoc:
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

        # Public: Create a test that you don't want to actually run.
        # This can be handy if you want to temporarily keep a test from
        # running, but don't want to deal with comments or if (false) blocks.
        # Tests skipped this way will generate a warning to the standard error.
        # Arguments are indentical to #test_that
        def skip_a_test_that(description=nil,&block)
          description = make_up_name(block) if description.nil?
          STDERR.puts "warning: test 'test that #{description}' is being skipped" unless $FOR_TESTING_ONLY_SKIP_STDERR
        end

        # Public: Create a test that is pending or that you intend to implement soon.
        # This can be handy for sketching out some tests that you want, as this will
        # print the pending tests to the standard error
        def someday_test_that(description=nil,&block)
          description = make_up_name(block) if description.nil?
          STDERR.puts "warning: test 'test that #{description}' is pending" unless $FOR_TESTING_ONLY_SKIP_STDERR
        end

        private 

        def make_up_name(some_proc)
          if some_proc.respond_to? :source_location
            name,location = some_proc.source_location
            "anonymous test at #{name}, line #{location} passes"
          else
            "anonymous test for proc #{some_proc.object_id} passes"
          end
        end
      end

    end
  end
end
