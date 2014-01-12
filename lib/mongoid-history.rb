require "easy_diff"
require "state_machine/core"

root = File.dirname(__FILE__)

# base
require "#{root}/mongoid/history"
require "#{root}/mongoid/history/helper"
require "#{root}/mongoid/history/errors"

# association chain
require "#{root}/mongoid/history/association/node"
require "#{root}/mongoid/history/association/chain"
require "#{root}/mongoid/history/association/array_builder"
require "#{root}/mongoid/history/association/document_builder"

# builders
require "#{root}/mongoid/history/builder/abstract"
require "#{root}/mongoid/history/builder/attributes"
require "#{root}/mongoid/history/builder/redo_attributes"
require "#{root}/mongoid/history/builder/undo_attributes"
require "#{root}/mongoid/history/builder/track"
require "#{root}/mongoid/history/builder/track_query"

# attribute delta
require "#{root}/mongoid/history/delta"
require "#{root}/mongoid/history/delta/abstract_state"
require "#{root}/mongoid/history/delta/create_state"
require "#{root}/mongoid/history/delta/update_state"
require "#{root}/mongoid/history/delta/destroy_state"

# operations
require "#{root}/mongoid/history/operation/attributes_fsm"
require "#{root}/mongoid/history/operation/abstract"
require "#{root}/mongoid/history/operation/redo"
require "#{root}/mongoid/history/operation/undo"
require "#{root}/mongoid/history/operation/track"

# proxy
require "#{root}/mongoid/history/proxy"

# switch
require "#{root}/mongoid/history/switch"

# meta
require "#{root}/mongoid/history/meta"

# tracker
require "#{root}/mongoid/history/tracker"

# trackable
require "#{root}/mongoid/history/trackable"

# sweeper
require "#{root}/mongoid/history/sweeper"

Dir["#{}/mongoid/**/*.rb"].sort.each { |f| require f }
