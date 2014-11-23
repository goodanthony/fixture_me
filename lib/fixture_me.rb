require "fixture_me/version"
require 'fileutils'
module FixtureMe

   def add_fixture
     hash = self.attributes
     md5 = Digest::MD5.hexdigest(hash.to_s)
     string = "#{md5}:\n"
     hash.each do |key,value|
       value.gsub!("\n","\n"+" "*4) if value.class == String
       string += " "*2 + "#{key.to_s}: #{value}\n" unless value.nil?
     end
     string += "\n"
     table_name = self.class.table_name
     file_name = table_name + ".yml"
     File.open("#{Rails.root}/test/fixtures/#{file_name}", 'a') do |out|
       out.write(string)
     end
   end


   def add_fixture_no_id_timestamps
     hash = self.attributes.delete_if { |k, v| ["created_at", "updated_at", "id"].include? k }
     md5 = Digest::MD5.hexdigest(hash.to_s)
     string = "#{md5}:\n"
     hash.each do |key,value|
       value.gsub!("\n","\n"+" "*4) if value.class == String
       string += " "*2 + "#{key.to_s}: #{value}\n" unless value.nil?
     end
     string += "\n"
     table_name = self.class.table_name
     file_name = table_name + ".yml"
     File.open("#{Rails.root}/test/fixtures/#{file_name}", 'a') do |out|
       out.write(string)
     end
   end



  class AddFixtures


     def  initialize
        @fixtures_dir =  FileUtils.mkdir_p( "#{Rails.root}/tmp/fixtures/").first
     end

     def fixtures_dir
       @fixtures_dir
     end


     def all_models
       # must eager load all the classes...
       Dir.glob("#{RAILS_ROOT}/app/models/**/*.rb") do |model_path|
         begin
          require model_path
         rescue
          # ignore
        end
      end
       # simply return them
       ActiveRecord::Base.send(:subclasses)
        #Dir.glob("#{Rails.root}/app/models/*.rb").map{|x| x.split("/").last.split(".").first.camelize}
      end



     def  get_list_of_unique_models_with_db_table


              table_names = ActiveRecord::Base.connection.tables #.map{|a| a.capitalize.singularize}
              model_names = Dir["#{Rails.root}/app/models/**/*.rb"].map {|f| File.basename(f, '.*').pluralize}

              #Rails.application.eager_load! unless Rails.configuration.cache_classes
              #ActiveRecord::Base.descendants
              modelswithtables =  table_names & model_names

     end


     def  create_fixture(table_name, sql, model)

        File.open("#{fixtures_dir}#{table_name}.yml", "w") do |file|
          objects = ActiveRecord::Base.connection.select_all(sql)
          objects.each_with_index do |obj, i|
                model.columns.each do |col|
                  if !col.null && obj[col.name].nil?
                    obj[col.name] = ''
                  end
                end
            file.write({"#{table_name}#{i}" => obj}.to_yaml.sub('---', ''))
            file.write "\n"
          end
        end


     end


     def create_all_fixtures

      modelswithtables = get_list_of_unique_models_with_db_table

      modelswithtables.each do |table_name|
            model = table_name.classify.constantize


            if model.columns.any?{|c| c.name == 'created_at'}
              sql = "SELECT * FROM #{table_name} ORDER BY created_at DESC"
            else
              sql = "SELECT * FROM #{table_name}"
            end

            self.create_fixture(table_name, sql, model)

            puts "extracted #{table_name}"
          end

     end




     def create_all_fixtures_no_timestamps

      modelswithtables = get_list_of_unique_models_with_db_table
      exclude_columns = ['created_at', 'updated_at']


      modelswithtables.each do |table_name|
            model = table_name.classify.constantize
            columns = model.attribute_names - exclude_columns

            if model.columns.any?{|c| c.name == 'created_at'}
              #sql = "SELECT * FROM #{table_name} ORDER BY created_at DESC"
                sql =   model.select(columns).order("created_at DESC").to_sql
            else
              #sql = "SELECT * FROM #{table_name}"
               sql =   model.select(columns).to_sql
            end

            self.create_fixture(table_name, sql, model)

            puts "extracted #{table_name}"
          end

     end




  #FixtureMe::AddFixtures.create_all_fixtures
  end



end
ActiveRecord::Base.send(:include, FixtureMe)

#c = FixtureMe::AddFixtures.new
#c.create_all_fixtures
