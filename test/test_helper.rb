require 'rubygems'
require "minitest/autorun"
require 'active_record'
require 'logger'

libpath = File.dirname(__FILE__)
$LOAD_PATH.unshift File.join(libpath, "..", "lib")

require_relative "../lib/fixture_me"


ActiveRecord::Base.establish_connection 'sqlite3::memory:'
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table "tasks", force: true do |t|
    t.string   "name"
  end

  create_table "servers" do |t|
    t.string "name"
    t.string "server_type"
  end

  create_table "servers_tasks", :id => false do |t|
    t.references :task
    t.references :server
  end
end

class Task < ActiveRecord::Base
 end
class Server < ActiveRecord::Base

end


# Load fixtures from the engine
#if ActiveSupport::TestCase.method_defined?(:fixture_path=)
#  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
#end
