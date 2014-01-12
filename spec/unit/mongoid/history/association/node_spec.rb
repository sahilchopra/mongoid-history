require 'spec_helper'

describe Mongoid::History::Association::Node do
  let(:subject) { node }
  let(:node)    { klass.new 'doors', 1234, "Door", door }
  let(:klass)   { Mongoid::History::Association::Node }

  let(:car)     { Car.new }
  let(:door)    { Door.new car: car }
  let(:window)  { Window.new door: door }

  describe "#initialize" do
    its(:name)        { should == 'doors'  }
    its(:id)          { should == 1234     }
    its(:class_name)  { should == "Door"   }
    its(:doc)         { should == door     }
  end

  describe "#to_hash" do
    let(:subject) { node.to_hash }

    it { should eql 'name' => 'doors', 'id' => 1234, 'class_name' => "Door" }
  end

  describe "#==" do
    context "with same attributes" do
      let(:subject) { node == klass.new('doors', 1234, "Door", door) }

      it { should be true }
    end

    context "with different doc" do
      let(:subject) { node == klass.new('doors', 1234, "Door", window) }

      it { should be false }
    end

    context "with different id" do
      let(:subject) { node == klass.new('doors', 1111, "Door", door) }

      it { should be false }
    end

    context "with different name" do
      let(:subject) { node == klass.new('foo', 1234, "Door", door) }

      it { should be false }
    end

    context "with different class_name" do
      let(:subject) { node == klass.new('doors', 1234, "Foo", door) }

      it { should be false }
    end
  end

  describe "#embeds_one?" do
    context "when doc has specified embedded object" do
      let(:subject) { node.embeds_one?('window') }
      it { should be true }
    end

    context "when doc has no specified embedded object" do
      let(:subject) { node.embeds_one?('car') }
      it { should be false }
    end
  end

  describe "#embeds_many?" do
    let(:node) { klass.new 'Car', 1234, 'Car', car }
    context "when doc has specified embedded object" do
      let(:subject) { node.embeds_many?('doors') }
      it { should be true }
    end

    context "when doc has no specified embedded object" do
      let(:subject) { node.embeds_many?('windows') }
      it { should be false }
    end
  end

  describe "#child_association" do
    let(:subject) { node.child_association('window') }

    it { should equal door.reflect_on_association('window') }
  end

  describe "#child_association_type" do
    context "when child association is embeds_one" do
      let(:subject) { node.child_association_type('window') }

      it { should equal Mongoid::Relations::Embedded::One }
    end

    context "when child association is embeds_one" do
      let(:node)    { klass.new 'Car', 1234, 'Car', car }
      let(:subject) { node.child_association_type('doors') }

      it { should equal Mongoid::Relations::Embedded::Many }
    end

  end
end
