module Mongoid::History::Operation
  class AttributesFSM
    extend StateMachine::MacroMethods

    attr_reader :attributes, :attr_builder
    def initialize(operation, attributes_builder)
      super() # state machine initialize
      @op           = operation
      @attr_builder = attributes_builder
      @attributes   = {}
    end

    def doc
      @op.doc
    end

    def current_track
      @op.current_track
    end

    state_machine :state, initial: :pending do
      event :prepare do
        transition pending: :persisted,    if: :doc_persisted?
        transition pending: :unpersisted,  unless: :doc_persisted?
      end

      event :create do
        transition unpersisted: :persisted
      end

      event :update do
        transition persisted: :persisted
      end

      event :destroy do
        transition persisted: :unpersisted
      end

      after_transition on: :create,  do: :fill_attributes
      after_transition on: :update,  do: :modify_attributes
      after_transition on: :destroy, do: :clear_attributes
    end

    def doc_persisted?
      doc && doc.persisted?
    end

    def fill_attributes
      @attributes = current_track.modified
    end

    def modify_attributes
      @attributes.merge! attr_builder.new(doc).build(current_track)
    end

    def clear_attributes
      @attributes = {}
    end
  end
end
