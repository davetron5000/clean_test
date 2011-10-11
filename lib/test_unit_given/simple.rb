module TestUnitGiven
  # A simple form that doesn't enforce the use of 
  # Given/When/Then.  This is merely to make it clear
  # which parts of your test do what
  module Simple
    # Public: Set up the conditions for the test
    #
    # existing_block - a callable object (e.g. a Proc) that will be called immediately
    #                  by this Given.  If nil, &block is expected to be passed
    # block          - a block given to this call that will be executed immediately
    #                  by this Given.  If existing_block is non-nil, this is ignored
    #
    # Examples
    #     
    #     given_block = Given {
    #       @foo = "bar"
    #     }
    #     # => executes block and returns it
    #     Given given_block
    #     # => executes the block again
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
    #     when_block = When {
    #       @foo.go
    #     }
    #     # => executes block and returns it
    #     When when_block
    #     # => executes the block again
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
    #     then_block = Then {
    #       assert_equal "bar",@foo
    #     }
    #     # => executes block and returns it
    #     Then then_block
    #     # => executes the block again
    #
    # Returns the block that was executed
    def Then(existing_block=nil,&block)
      Given(existing_block,&block)
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
