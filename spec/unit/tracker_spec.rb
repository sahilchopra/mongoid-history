require 'spec_helper'

describe Mongoid::History::Tracker do
  before { Mongoid::History.tracker_class_name = nil }
  it "should set tracker_class_name when included" do
    class MyTracker
      include Mongoid::History::Tracker
    end
    Mongoid::History.tracker_class_name.should == :my_tracker
  end
end
