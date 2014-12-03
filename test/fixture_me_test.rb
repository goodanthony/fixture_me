require File.join(File.dirname(__FILE__), 'test_helper.rb')
require 'yaml'

class FitureMeTest < Minitest::Test


    def test_check_for_add_fixture_no_id_timestamps_file
      the_file = "#{Dir.pwd}/test/fixtures/tasks.yml"
      File.delete(the_file) if File.exist?(the_file)
      task = Task.create! name: "test"
      tsk = Task.first.add_fixture_no_id_timestamps
      assert  File.exists?(the_file), "tasks.tml file is not there"
      parsing = YAML.load_file(the_file)
      first_itm = parsing.keys[0]
      exp_hasg = {"name"=> "test"}.to_s
      assert_equal exp_hasg, parsing[first_itm].to_s
    end


    def test_check_for_add_fixture_no_id_timestamps_file
      the_file = "#{Dir.pwd}/test/fixtures/tasks.yml"
      File.delete(the_file) if File.exist?(the_file)
      task = Task.create! name: "test"
      tsk = Task.first.add_fixture
      assert  File.exists?(the_file), "tasks.tml file is not there"
      parsing = YAML.load_file(the_file)
      first_itm = parsing.keys[0]
      exp_hasg = {"id" => 1, "name"=> "test"}.to_s
      assert_equal exp_hasg, parsing[first_itm].to_s
    end


    def test_check_for_add_fixture_no_id_timestamps_file
      the_file = "#{Dir.pwd}/test/fixtures/tasks.yml"
      File.delete(the_file) if File.exist?(the_file)
      task = Task.create! name: "test"
      server1 = Server.create! name: "main1", server_type: "main"
      server2 = Server.create! name: "main2", server_type: "main"
      fixme = FixtureMe::AddFixtures.new
      assert fixme.create_all_fixtures_no_timestamps
    end



end
