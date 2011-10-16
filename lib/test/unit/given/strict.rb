module Test
  module Unit
    module Given
      # A strict Given/When/Then that will generate errors if you
      # omit any one of these in your test.
      module Strict
        include Simple

        def setup
          @__next = :given
        end

        # Set up the conditions for the test, see Test::Unit::Given::Simple::Given
        def Given(existing_block=nil,&block)
          @__next = :when
          call_block_param_or_block_given(existing_block,&block)
          end
        # Execute the code under test, failing if no Given was called first, see Test::Unit::Given::Simple::When
        def When(existing_block=nil,&block)
          raise "No Given block?" unless @__next == :when
          @__next = :then
          call_block_param_or_block_given(existing_block,&block)
          end
        # Verify the results of the test, failing if no When was called first, see Test::Unit::Given::Simple::Then
        def Then(existing_block=nil,&block)
          raise "No When block?" unless @__next == :then
          @__next = :given
          call_block_param_or_block_given(existing_block,&block)
        end
      end
    end
  end
end

