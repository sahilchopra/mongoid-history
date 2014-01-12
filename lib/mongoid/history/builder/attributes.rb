module Mongoid::History::Builder
  class Attributes < Abstract
    def affected(track)
      (track.modified.keys | track.original.keys).inject({}) do |h, k|
        h[k] = doc ? doc.attributes[k] : track.modified[k]
        h
      end
    end
  end
end
