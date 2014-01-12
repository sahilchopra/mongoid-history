module Mongoid::History::Builder
  class Track < Abstract
    def history_delta
      @history_delta ||= Mongoid::History::Delta.new(doc)
    end

    def switch
      @switch ||= Mongoid::History.switch(doc.class)
    end

    def modifier
      doc.send(meta.modifier_field)
    end

    def version
      doc.send(meta.version_field) || 0
    end

    def attributes(action)
      original, modified = history_delta.on(action).results

      return if original.blank? && modified.blank?

      {
        association_chain: association_chain,
        scope: meta.scope,
        original: original,
        modified: modified,
        modifier: modifier,
        version: version,
        action: action
      }
    end

    def build(action)
      attr = attributes(action)
      meta.tracker.new(attr) if attr
    end
  end
end
