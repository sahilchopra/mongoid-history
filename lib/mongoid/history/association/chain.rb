module Mongoid::History::Association
  class Chain < Array
    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(array)
        ArrayBuilder.new(array).build
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
        when Chain
          object.mongoize
        when Array
          object
        else
          raise  ArgumentError, "#{objct.class} is not a valid Mongoid::History::Association::Chain"
        end
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      alias_method :evolve, :mongoize

      def build_from_doc(doc)
        DocumentBuilder.new(doc).build
      end
    end

    def leaf
      last
    end

    def root
      first
    end

    def parents
      self[0..-2]
    end

    def parent
      parents.last
    end

    def to_a
      map(&:to_hash)
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
      to_a
    end

  end
end
