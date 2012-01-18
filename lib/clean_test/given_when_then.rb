module Clean #:nodoc:
  module Test #:nodoc:
    # A means of documenting the parts of your test code according
    # to the class "Given/When/Then" system.
    # This does no enforcement of any kind and is merely documentation to make
    # your tests readable.
    #
    # Example:
    #
    #     Given {
    #       @circle = Circle.new(10)
    #     }
    #     When {
    #       @area = @circle.area
    #     }
    #     Then {
    #       assert_equal 314,@area
    #     }
    #
    # There are also two additional methods provided ,#the_test_runs and
    # #mocks_shouldve_been_called to assist with creating readable tests that use mocks.  See those
    # methods for an example
    module GivenWhenThen
      # Public: Set up the conditions for the test
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this Given.  If nil, &block is expected to be passed
      # block          - a block given to this call that will be executed immediately
      #                  by this Given.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     Given {
      #       @foo = "bar"
      #     }
      #
      # Returns the block that was executed
      def Given(existing_block=nil,&block)
        call_block_param_or_block_given(existing_block,&block)
      end
      # Public: Execute the code under test
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this When.  If nil, &block is expected to be passed
      # block          - a block given to this call that will be executed immediately
      #                  by this When.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     When {
      #       @foo.go
      #     }
      #
      # Returns the block that was executed
      def When(existing_block=nil,&block)
        Given(existing_block,&block)
      end

      # Public: Verify the results of the test
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this Then.  If nil, &block is expected to be passed
      # block          - a block given to this call that will be executed immediately
      #                  by this Then.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     Then {
      #       assert_equal "bar",@foo
      #     }
      #
      # Returns the block that was executed
      def Then(existing_block=nil,&block)
        Given(existing_block,&block)
      end

      # Public: Continue the previous Given/When/Then in a new block.  The reason
      # you might do this is if you wanted to use the existing block form of a
      # Given/When/Then, but also need to do something custom.  This allows you to 
      # write your test more fluently.
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this Then.  If nil, &block is expected to be passed
      # block          - a block given to this call that will be executed immediately
      #                  by this Then.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     def circle(radius)
      #       lambda { @circle = Circle.new(radius) }
      #     end
      #
      #     Given circle(10)
      #     And {
      #       @another_circle = Circle.new(30)
      #     }
      #
      # Returns the block that was executed
      def And(existing_block=nil,&block)
        Given(existing_block,&block)
      end

      # Public: Continue the previous Given/When/Then in a new block.  The reason
      # you might do this is if you wanted to use the existing block form of a
      # Given/When/Then, but also need to do something custom, and that custom thing
      # contradicts or overrides the flow, so an "And" wouldn't read properly.  This allows you to 
      # write your test more fluently.
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this Then.  If nil, &block is expected to be passed
      # block          - a block given to this call that will be executed immediately
      #                  by this Then.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     def options
      #       lambda {
      #         @options = {
      #           :foo => 'bar',
      #           :quux => 'baz',
      #         }
      #       }
      #     end
      #
      #     Given options
      #     But {
      #       @options[:foo] = 'baz'
      #     }
      #
      # Returns the block that was executed
      def But(existing_block=nil,&block)
        Given(existing_block,&block)
      end

      # Public: Used to make clear the structure of tests using mocks.
      # This returns a no-op, and is intended to be used with a "When"
      # to delineate the creation of a mock in a Given, and the 
      # expectations of a mock in a "Then"
      #
      # Example:
      #
      #     Given {
      #       @google = mock()
      #     }
      #     When the_test_runs
      #     Then {
      #       @google.expects(:search).with('foo').returns('bar')
      #     }
      #     Given {
      #       @my_search = Search.new(@google)
      #     }
      #     When {
      #       @result = @my_search.find('foo')
      #     }
      #     Then {
      #       assert_equal 'Found bar',@result
      #     }
      #     And mocks_shouldve_been_called
      def the_test_runs
        lambda {}
      end

      # Public: Similar to #the_test_runs, this is used to make clear what
      # you are testing and what the assertions are.  Since many Ruby mock
      # frameworks do not require an explicit "verify" step, you often have tests
      # that have no explicit asserts, the assertions being simply that the mocks were called
      # as expected.  This step, which is a no-op, allows you to document that you are 
      # expecting mocks to be called. See the example in #mocks_are_called for usage.
      def mocks_shouldve_been_called
        lambda {}
      end

      private

      def call_block_param_or_block_given(existing_block,&block)
        if existing_block.nil?
          block.call
          block
        else
          existing_block.call
          existing_block
        end
      end
    end
  end
end
