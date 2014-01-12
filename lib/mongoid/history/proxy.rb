module Mongoid::History
  class Proxy
    include Helper

    attr_accessor :doc

    def initialize(doc)
      @doc = doc
    end

    def build_tracks(versions)
      versions ||= doc.version
      Mongoid::History::Builder::TrackQuery.new(doc).build(versions).to_a
    end

    def track!(action)
      Operation::Track.new(doc).execute!(action)
    end

    def undo!(modifier, versions)
      Operation::Undo.new(doc).execute!(modifier, build_tracks(versions).reverse)
    end

    def redo!(modifier, versions)
      Operation::Redo.new(doc).execute!(modifier, build_tracks(versions))
    end

    def history
      binding.pry
      meta.tracker.where(
        scope: meta.scope,
        association_chain: association_chain.root
      )
    end
  end
end
