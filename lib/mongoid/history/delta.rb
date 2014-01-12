module Mongoid::History
  class Delta
    attr_reader :doc
    delegate    :results, to: "@current_state"

    def initialize(doc)
      @doc            = doc
      @states         = {}
      @current_state  = nil
    end

    def state_class(name)
      "Mongoid::History::Delta::#{name.to_s.classify}State".constantize
    end

    # Delta.new(doc).on(:create).results
    def on(name)
      klass = state_class(name)
      @states[name] ||= klass.new(doc)
      @current_state = @states[name]
      self
    end
  end
end
