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
      # Public: Declarea step in your test, based on the following conventions:
      #
      # Given - This sets up conditions for the test
      # When  - This executes the code under test
      # Then  - This asserts that that the code under test worked correctly
      # And   - Extend a Given/When/Then when using lambda/method form (see below)
      # But   - Extend a Given/When/Then when using lambda/method form (see below)
      #
      # There are three forms for calling this method, in order of preference:
      #
      # block  - in this form, you pass a block that contains the test code.  This should be preferred as it
      #          keeps your test code in your test
      # method - in this form, you pass a symbol that is the name of a method in your test class.  This method
      #          should set or perform or assert whatever is needed.  This can be useful to re-use test helper
      #          methods in an expedient fashion.  In this case, you can pass parameters by simply listing
      #          them after the symbol.  See the example.
      # lambda - in this form, you declare a method that returns a lambda and that is used as the
      #          block for this step of the test.  This is least desirable, as it requires methods to return
      #          lambdas, which is an extra bit of indirection that adds noise.
      #
      # Parameters:
      #
      # existing_block - a callable object (e.g. a Proc) that will be called immediately
      #                  by this Given.  If this is a Symbol, a method in the current scope will be converted into
      #                  a block and used. If nil, &block is expected to be passed
      # other_args     - a list of arguments to be passed to the block.  This is mostly useful when using method form.
      # block          - a block given to this call that will be executed immediately
      #                  by this Given.  If existing_block is non-nil, this is ignored
      #
      # Examples
      #     
      #     # block form
      #     Given {
      #       @foo = "bar"
      #     }
      #
      #     # method form
      #     def assert_valid_person
      #       assert @person.valid?,"Person invalid: #{@person.errors.full_messages}"
      #     end
      #
      #     Given {
      #       @person = Person.new(:last_name => 'Copeland', :first_name => 'Dave')
      #     }
      #     Then :assert_valid_person
      #
      #     # method form with arguments
      #     def assert_invalid_person(error_field)
      #       assert !@person.valid?
      #       assert @person.errors[error_field].present?
      #     end
      #
      #     Given {
      #       @person = Person.new(:last_name => 'Copeland')
      #     }
      #     Then :assert_invalid_person,:first_name
      #
      #     # lambda form
      #     def assert_valid_person
      #       lambda { 
      #         assert @person.valid?,"Person invalid: #{@person.errors.full_messages}"
      #       }
      #     end
      #
      #     Given {
      #       @person = Person.new(:last_name => 'Copeland', :first_name => 'Dave')
      #     }
      #     Then assert_valid_person
      #
      # Returns the block that was executed
      def Given(existing_block=nil,*other_args,&block)
        if existing_block.nil?
          block.call(*other_args)
          block
        else
          if existing_block.kind_of?(Symbol)
            existing_block = method(existing_block)
          end
          existing_block.call(*other_args)
          existing_block
        end
      end

      alias :When :Given
      alias :Then :Given
      alias :And :Given
      alias :But :Given

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
      # expecting mocks to be called (rather than forgot to assert anything). 
      # See the example in #mocks_are_called for usage.
      def mocks_shouldve_been_called
        lambda {}
      end
    end
  end
end
