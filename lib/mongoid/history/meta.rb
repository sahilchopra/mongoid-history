module Mongoid::History
  class Meta
    DEFAULT_OPTIONS = {
      on: :all,
      except: [:_id, :id, :created_at, :updated_at],
      modifier_field: :modifier,
      version_field: :version,
      track_create: false,
      track_update: true,
      track_destroy: false,
    }

    attr_reader :klass, :options, :switch

    def initialize(klass, opts = {})
      @klass    = klass
      @options  = DEFAULT_OPTIONS.merge opts
      @switch   = Switch.new(klass)
    end

    def normalize_fields(*fields)
      fields.flatten.uniq.compact.map(&:to_sym)
    end

    def except_fields
      @except_fields ||= normalize_fields(
        options[:except],   # user configured or default except fields
        version_field,      # contains current version
        modifier_id_field,  # contains the last modifier who is responsible for the change
        DEFAULT_OPTIONS[:except]
      )
    end

    def only_fields
      @only_fields ||= normalize_fields(
        options[:only],
        options[:on]
      )
    end

    def track_all_fields?
      @track_all_fields ||= only_fields.include?(:all)
    end

    def version_field
      @version_field ||= options[:version_field].to_sym
    end

    def modifier_field
      @modifier_field ||= options[:modifier_field].to_sym
    end

    def modifier_class_name
      Mongoid::History.modifier_class_name
    end

    def modifier_id_field
      @modifier_id_field ||= "#{modifier_field}_id".to_sym
    end

    def scope
      @scope ||= @options[:scope] || model_name
    end

    def model_name
      klass.name.tableize.singularize.to_sym
    end

    def tracker
      Mongoid::History.tracker_class
    end

    def track?(action)
      switch.on? && !!options["track_#{action}".to_sym]
    end
  end
end
