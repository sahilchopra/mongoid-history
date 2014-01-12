module Mongoid::History::Builder
  class RedoAttributes < Attributes
    def build(track)
      affected(track)
        .easy_unmerge(track.original)
        .easy_merge(track.modified)
    end
  end
end
