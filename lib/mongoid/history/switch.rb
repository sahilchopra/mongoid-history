module Mongoid::History
  class Switch
    attr_reader :model
    def initialize(model)
      @model = model
      on!
    end

    def track_name
      "mongoid_history_#{model.name}_trackable_enabled".to_sym
    end

    def on?
      Thread.current[track_name]
    end

    def on!
      Thread.current[track_name] = true
    end

    def off!
      Thread.current[track_name] = false
    end

    def disable
      off!
      yield
    ensure
      on!
    end
  end
end
