module Mongoid
  module History
    mattr_accessor :modifier_class_name
    mattr_accessor :current_user_method
    mattr_accessor :tracker_class_name

    mattr_accessor :metas
    mattr_accessor :switches

    self.metas                = {}
    self.switches             = {}
    self.modifier_class_name  = "User"
    self.current_user_method  = :current_user

    def self.tracker_class
      tracker_class_name.constantize
    end

    def self.tracker_class=(klass)
      @tracker_class_name = klass.name
    end

    def self.register(model, opts)
      metas[model.name]     = Meta.new(model, opts)
      switches[model.name]  = Switch.new(model)
    end

    def self.meta(model)
      metas[model.name]
    end

    def self.switch(model)
      switches[model.name]
    end
  end
end
