module Mongoid
  module History
    GLOBAL_TRACK_HISTORY_FLAG = "mongoid_history_trackable_enabled"

    mattr_accessor :tracker_class_name
    mattr_accessor :trackable_class_options
    mattr_accessor :modifier_class_name
    mattr_accessor :current_user_method

    class << self

      def set_tracker_class_name(value)
        @@tracker_class_name ||= value
      end

      def disable(&block)
        Thread.current[GLOBAL_TRACK_HISTORY_FLAG] = false
        yield
      ensure
        Thread.current[GLOBAL_TRACK_HISTORY_FLAG] = true
      end

      def enabled?
        Thread.current[GLOBAL_TRACK_HISTORY_FLAG] != false
      end
    end
  end
end
