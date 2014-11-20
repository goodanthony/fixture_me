require "fixture_me/version"

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



  class AddFixtures


     def self.create_all_fixtures

      fixtures_dir = "#{Rails.root}/tmp/fixtures/"
      FileUtils.mkdir_p(fixtures_dir)

      table_names = ActiveRecord::Base.connection.tables #.map{|a| a.capitalize.singularize}
      model_names = Dir["#{Rails.root}/app/models/**/*.rb"].map {|f| File.basename(f, '.*').pluralize}
      modelswithtables =    table_names & model_names
      modelswithtables.each do |table_name|
            model = table_name.classify.constantize


            if model.columns.any?{|c| c.name == 'created_at'}
              sql = "SELECT * FROM #{table_name} ORDER BY created_at DESC"
            else
              sql = "SELECT * FROM #{table_name}"
            end
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
            puts "extracted #{table_name}"
          end

     end

  #FixtureMe::AddFixtures.create_all_fixtures
  end



end
ActiveRecord::Base.send(:include, FixtureMe)
