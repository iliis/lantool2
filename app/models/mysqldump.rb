# Source: https://gist.github.com/ceneon/1090315

# USAGE:

#require RAILS_ROOT + "/lib/" + "mysqldump.rb"   
#dump = Mysqldump.full_backup
#response.headers['Content-Type'] = 'text/plain'
#response.headers['Content-Disposition'] = 'attachment; filename=DATABASE_' + Date.today.to_s + '.bak'
#render :text => dump     


class Mysqldump  
# ref: http://pauldowman.com/2009/02/08/mysql-s3-backup/
   require "rubygems"
   require "fileutils"

   def self.get_config
     mysql = {}
     
     info = YAML::load(IO.read(Rails.root.join("config", "database.yml")))
     mysql[:database] = info[Rails.env]["database"]
     mysql[:user]     = info[Rails.env]["username"]
     mysql[:password] = info[Rails.env]["password"]  
     mysql
   end

   def self.get_tmp_file_path
     #@temp_dir = "/tmp/mysql-backup"
     #FileUtils.mkdir_p @temp_dir
     #"#{@temp_dir}/dump.sql.gz"
     "/tmp/dump_#{DateTime.now.to_i}.sql.gz"
   end

   def self.full_backup
     mysql = get_config
     dump_file = get_tmp_file_path

     cmd = "mysqldump #{mysql[:database]} -u #{mysql[:user]} -p'#{mysql[:password]}' "
     cmd += " | gzip -c > #{dump_file}"   

     run(cmd)

     ret = File.new(dump_file).read
     FileUtils.rm(dump_file)
     ret              
   end #full_backup

   def self.full_import(data)
     dump_file = get_tmp_file_path

     File.open(dump_file, 'wb') do |f| f.write(data) end

     full_import_from_file(dump_file)

     FileUtils.rm(dump_file)
   end

   def self.full_import_from_file(file)
     mysql = get_config

     run("gunzip -c #{file} > /tmp/foo.sql")
     run("mysql #{mysql[:database]} -u #{mysql[:user]} -p'#{mysql[:password]}' < /tmp/foo.sql")
     FileUtils.rm("/tmp/foo.sql")
   end

   def self.clear_all
     # this is quite slow, as it recreates everything from the migrations
     # consider using TRUNCATE or something if it is too slow
     Rake::Task['db:reset'].invoke
   end



   def self.run(command)
     result = system(command)
     raise("error, process exited with status #{$?.exitstatus}.\nCommand: #{command}\nOutput: #{result}") unless $?.exitstatus == 0
   end

end
