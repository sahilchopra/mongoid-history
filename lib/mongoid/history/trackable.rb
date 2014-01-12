module Mongoid::History::Trackable
  extend ActiveSupport::Concern

  module ClassMethods
    def track_history(opts = {})
      Mongoid::History.register(self, opts)

      meta = Mongoid::History.meta(self)

      field meta.version_field, type: Integer, default: 0
      belongs_to meta.modifier_field, class_name: meta.modifier_class_name

      include MyInstanceMethods

      [:create, :update, :destroy].each do |action|
        set_callback action, :before do |document|
          trackable_proxy.track!(action)
        end
      end
    end
  end

  module MyInstanceMethods
    def trackable_proxy
      @trackable_proxy ||= Mongoid::History::Proxy.new(self)
    end

    def undo!(modifier, options_or_version = nil)
      trackable_proxy.undo!(modifier, options_or_version)
    end

    def redo!(modifier, options_or_version = nil)
      trackable_proxy.redo!(modifier, options_or_version)
    end

    def history_tracks
      trackable_proxy.history
    end
  end
end
