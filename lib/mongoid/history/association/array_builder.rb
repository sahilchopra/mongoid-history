module Mongoid::History::Association
  class ArrayBuilder
    def initialize(array)
      @array = array.dup
    end

    def build
      Chain.new.tap do |chain|
        chain.push build_root
        while (hash = @array.shift)
          child = build_child(chain.last, hash)
          chain.push child
        end
      end
    end

    def build_root
      hash  = @array.shift
      name  = hash['name']
      id    = hash['id']
      model = name.constantize
      doc   = query_doc model, id

      Node.new(name, id, name, doc)
    end

    def build_child(parent, hash)
      name        = hash['name']
      id          = hash['id']
      class_name  = hash['class_name']
      return Node.new name, id, class_name, nil unless parent.doc

      doc   = if parent.embeds_one?(name)
                parent.doc.send name
              elsif parent.embeds_many?(name)
                collection = parent.doc.send name
                query_doc collection, id
              else
                nil
              end

      Node.new(name, id, class_name, doc)
    end

    def query_doc(model_or_collection, id)
      model_or_collection.where(_id: id).first
    end
  end
end
