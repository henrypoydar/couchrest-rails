module CouchRestRails
  module Views

    extend self

    def push(database, view)

      puts "database = #{database} :: view=#{view}"

      return  "Database '#{database}' doesn't exists" unless (database == "*" ||
                                                              File.exist?(File.join(RAILS_ROOT, CouchRestRails.setup_path, database)))
      Dir[File.join(RAILS_ROOT, CouchRestRails.setup_path, database)].each do |db|
        result = []
        # check for a directory...
        if File::directory?(db)
          return "Views directory (#{db}/views) does not exist" unless File.exist?("#{db}/views")
          db_name =COUCHDB_CONFIG[:db_prefix] +  File.basename( db) +
            COUCHDB_CONFIG[:db_suffix]
          res = CouchRest.get("#{COUCHDB_CONFIG[:host_path]}/#{db_name}") rescue nil
          if res
            db_con = CouchRest.database("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
            Dir.glob(File.join(db,"views", view)).each do |design_doc|
              design_doc_name = File.basename(design_doc)
              views = assemble_views(design_doc)
              if views.empty?
                result << "No views were found in #{design_doc}/#{File.basename(design_doc)}"
              else
                db_con.save_doc({
                                  "_id" => "_design/#{design_doc_name}",
                                  :views => views
                                })
                result << "Added views the following views to _design/#{design_doc_name}: #{views.map {|k,v| k.to_s}.join(', ')}"
              end
            end

            puts "No views were found in '#{File.join(db,"views", view)}'" if result.empty?
          else
            return  "CouchDB database '#{db_name}' doesn't exist. create it first"
          end
        else
          return "CouchDB database '#{database}' doesn't exist"
        end

        puts "#{result.join("\n")}"
      end
    end

    def assemble_views(design_doc_path)
      views = {}

      Dir.glob(File.join(design_doc_path, '*')).each do |view_folder|
        view = {}
        view[:map] = IO.read(File.join(view_folder, 'map.js')) if File.exist?(File.join(view_folder, 'map.js'))
        view[:reduce] = IO.read(File.join(view_folder, 'reduce.js')) if File.exist?(File.join(view_folder, 'reduce.js')) && File.size(File.join(view_folder, 'reduce.js')) > 0
        views[File.basename(view_folder).to_sym] = view if view[:map]
      end
      views
    end
  end
end
