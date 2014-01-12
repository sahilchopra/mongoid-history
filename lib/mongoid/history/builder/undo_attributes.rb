module Mongoid::History::Builder
  class UndoAttributes < Attributes
    def build(track)
      affected(track)
        .easy_unmerge(track.modified)
        .easy_merge(track.original)
    end
  end
end
