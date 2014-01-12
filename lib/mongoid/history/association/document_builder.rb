module Mongoid::History::Association
  class DocumentBuilder
    def initialize(doc)
      @doc = doc
    end

    def build_node(doc)
      return nil unless doc
      name = name(doc)
      id   = doc.id
      class_name = doc.class.name
      Node.new(name, id, class_name, doc)
    end

    def build
      Chain.new.tap do |chain|
        current = @doc
        loop do
          current = current._parent
          break unless current
          chain.unshift build_node(current)
        end
      end
    end

    def name(doc)
      doc._parent ? association_name(doc) : model_name(doc)
    end

    def model_name(doc)
      doc.class.name
    end

    def association_name(doc)
      assoc = association(doc)
      assoc && assoc.inverse.to_s
    end

    def association(doc)
      doc.reflect_on_all_associations(:embedded_in).find do |assoc|
        doc._parent == doc.send(assoc.key)
      end
    end
  end
end
