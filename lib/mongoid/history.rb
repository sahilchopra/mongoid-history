module Mongoid
  module History
    GLOBAL_TRACK_HISTORY_FLAG = "mongoid_history_trackable_enabled"

    class << self
      attr_accessor :tracker_class_name
      attr_accessor :trackable_class_options
      attr_accessor :modifier_class_name
      attr_accessor :current_user_method

      def set_tracker_class_name(value)
        @tracker_class_name ||= value
      end

      def disable(&block)
        store[GLOBAL_TRACK_HISTORY_FLAG] = false
        yield
      ensure
        store[GLOBAL_TRACK_HISTORY_FLAG] = true
      end

      def enabled?
        store[GLOBAL_TRACK_HISTORY_FLAG] != false
      end

      def store
        defined?(RequestStore) ? RequestStore.store : Thread.current
      end
    end
  end
end
