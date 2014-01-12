module Mongoid::History::Builder
  class TrackQuery < Abstract
    def build(versions)
      doc
        .history_tracks
        .where(:version.in => extract_versions(versions))
        .asc(:version)
    end

    def extract_versions(arg)
      case arg
      when Fixnum
        [arg]
      when Array
        arg
      when Range
        arg.to_a
      when Hash
        normalize_options arg
      end.flatten.uniq.compact
    end

    def normalize_options(opts)
      if opts[:from] && opts[:to]
        range = [opts[:from].to_i, opts[:to].to_i]
        min = range.min
        max = range.max
        (min..max).to_a
      elsif opts[:last]
        max = doc.send meta.version_field
        min = max - opts[:last].to_i + 1
        min = [0, min].max
        (min..max).to_a
      else
        []
      end
    end
  end
end
