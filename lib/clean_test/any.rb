require 'faker'

module Clean #:nodoc:
  module Test #:nodoc:
    # Public: Provides the ability to vend arbitrary values without using literals, or
    # long calls to Faker.  This produced random values, so you must be sure that your code truly
    # should work with any value.  The random seed used will be output, and you can use
    # the environment variable +RANDOM_SEED+ to recreate the conditions of a particular test.
    #
    # Example:
    #
    #     class Person
    #       def initialize(first_name,last_name,age)
    #         # ...
    #       end
    #     end
    #
    #     test_that "someone under 18 is a minor" {
    #       Given {
    #         # First name and last name aren't relevant to the test
    #         @person = Person.new(any_string,any_string,17)
    #       }
    #       When {
    #         @minor = @person.minor?
    #       }
    #       Then {
    #         assert @minor
    #       }
    #     }
    #
    #     test_that "full_name gives the full name" {
    #       Given {
    #         # Age isn't relevant; it just needs to be positive
    #         @person = Person.new("Dave","Copeland",any_int :positive)
    #       }
    #       When {
    #         @full_name = @person.full_name
    #       }
    #       Then {
    #         assert_equal "Dave Copeland",@full_namej
    #       }
    #     }
    module Any
      def self.included(k)
        seed = if ENV['RANDOM_SEED']
                 ENV['RANDOM_SEED'].to_i
               else
                 srand() # generate random seed
                 seed = srand() # save it (but we've now generated another one)
               end
        srand(seed) # set it explicitly
        puts "Random seed was #{seed}; re-use it via environment variable RANDOM_SEED"
      end
      MAX_RAND = 50000 #:nodoc:

      # Public: Get any number; one that doesn't matter
      #
      # options - options to control what sort of number comes back:
      #           :positive - make sure that the number is greater than zero
      #           :negative - make sure that the number is less than zero
      def any_number(*options)
        number = (rand(2 * MAX_RAND) - MAX_RAND).to_f/100.0
        if options.include? :positive
          number + MAX_RAND
        elsif options.include? :negative
          number - MAX_RAND
        else
          number
        end
      end

      # Public: Returns an integer.  options is the same as for #any_number
      def any_int(*options)
        any_number(*options).to_i
      end

      # Public: Get an arbitrary string of any potential positive length
      #
      # options - options to control the returned string:
      #           :max - the max size of the string you want, must be positive and greater than :min
      #           :min - the minimum size we want to come back, must be positive and less than :max
      #
      # Example
      #
      #     any_string :max => 255 # => ensure it'll fit into a varchar(255)
      #     any_string :min => 1024 # at least 1024 characters
      #
      def any_string(options = {})
        if options[:min] && options[:max]
          raise ":min must be less than :max" if options[:min] > options[:max]
        end
        if options[:min]
          raise ":min must be positive" if options[:min] < 1
        end

        min_size = options[:min]
        max_size = options[:max]

        if min_size.nil? && max_size.nil?
          min_size = rand(80) + 1
          max_size = min_size + rand(80)
        elsif min_size.nil?
          min_size = max_size - rand(max_size)
          min_size = 1 if min_size < 1
        else
          max_size = min_size + rand(min_size) + 1
        end

        string = Faker::Lorem.words(1).join(' ')
        while string.length < min_size
          string += Faker::Lorem.words(1).join(' ') 
        end

        string[0..(max_size-1)]
      end

      # Public: Get an arbitrary symbol, for example to use as a Hash key.  The symbol
      # will be between 2 and 20 characters long.  If you need super-long symbols for some reason,
      # use <code>any_string.to_sym</code>.
      def any_symbol
        (any_string :min => 2, :max => 20).to_sym
      end

      # Public: Get an arbitrary sentence of arbitrary words of any potential length.  Currently,
      # this returns a sentence between 10 and 21 words, though you can control that with options
      #
      # options - options to control the returned sentence
      #           :max - the maximum number of words you want returned
      #           :min - the minimum number of words you want returned; the sentence will be between
      #                  :min and (:min + 10) words
      #
      # Example
      #
      #     any_sentence :min => 20  # at least a 20-word sentence
      #     any_sentence :max => 4   # no more than four words
      #
      def any_sentence(options = {})
        min = 11
        max = 21

        if options[:max]
          min = 1
          max = options[:max]
        elsif options[:min]
          min = options[:min]
          max = min + 10
        end

        Faker::Lorem.words(rand(max - min) + min).join(' ')
      end
    end
  end
end

