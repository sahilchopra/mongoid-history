module Mongoid::History::Operation
  class Redo < Abstract
    attr_reader :current_track
    def execute!(modifier, tracks)
      @fsm        = AttributesFSM.new(self, attr_builder)
      @tracks     = tracks
      @modifier   = modifier

      prepare!
      run!
      commit!

      @doc
    end

    def meta
      @meta ||= Mongoid::History.meta(doc_class)
    end

    def doc_class
      ( doc && doc.class) ||
        current_track.association_chain.leaf.class_name.constantize
    end

    def prepare!
      @fsm.prepare!
    end

    def run!
      until @tracks.empty?
        @current_track = @tracks.shift
        begin
          update_fsm
        rescue StateMachine::InvalidTransition
          raise Mongoid::History::InvalidOperation
        end
      end
      assign_modifier
    end

    def commit!
      case current_action
      when :create
        re_create!
      when :destroy
        re_destroy!
      else
        update!
      end
    end

    def update_fsm
      case current_action
      when :create
        @fsm.create!
      when :destroy
        @fsm.destroy!
      else
        @fsm.update!
      end
    end

    def attr_builder
      Mongoid::History::Builder::RedoAttributes
    end

    def attributes
      @fsm.attributes
    end

    def current_action
      (@current_track.action || 'update').to_sym
    end

    def assign_modifier
      attributes[meta.modifier_field] = @modifier
    end

    def re_create!
      @doc =  if current_track.association_chain.length > 1
                create_on_parent!
              else
                create_standalone!
              end
    end

    def create_on_parent!
      parent = current_track.association_chain.parent
      child  = current_track.association_chain.leaf

      if parent.embeds_one?(child.name)
        parent.doc.send("create_#{child.name}!", attributes)
      elsif parent.embeds_many?(child.name)
        parent.doc.send(child.name).create!(attributes)
      else
        raise Mongoid::History::InvalidOperation
      end
    end

    def create_standalone!
      name = current_track.association_chain.leaf.name
      model = name.constantize
      model.create!(attributes)
    end

    def re_destroy!
      doc.destroy
    end

    def update!
      @doc.update_attributes!(attributes)
    end
  end
end
