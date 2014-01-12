class Mongoid::History::Delta
  class CreateState < AbstractState
    def results
      original = {}
      modified = {}

      changes.each_pair do |k, v|
        o, m = v
        original[k] = o unless o.nil?
        modified[k] = m unless m.nil?
      end

      original.easy_diff modified
    end

    def changes
      sanitize doc.changes
    end

    def sanitize(change_set)
      if meta.track_all_fields?
        change_set.reject { |k, v| meta.except_fields.include?(k.to_sym) }
      else
        change_set.select { |k, v| meta.only_fields.include?(k.to_sym)  }
      end
    end
  end
end
