module CouchRestRails
  module Views

    extend self

    def push(database, view)

      puts "database = #{database} :: view = #{view}"
      return  "Database '#{database}' doesn't exists" unless (database == "*" || File.exist?(File.join(RAILS_ROOT, CouchRestRails.setup_path, database)))
      Dir[File.join(RAILS_ROOT, CouchRestRails.setup_path, database)].each do |db|
        result = []

        # check for a directory...
        if File::directory?(db)
          return "Views directory (#{db}/views) does not exist" unless File.exist?("#{db}/views")
          db_name = COUCHDB_CONFIG[:db_prefix] +  File.basename( db) + COUCHDB_CONFIG[:db_suffix]
          res = CouchRest.get("#{COUCHDB_CONFIG[:host_path]}/#{db_name}") rescue nil

          if res
            db_con = CouchRest.database("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
            Dir.glob(File.join(db,"views", view)).each do |design_doc|
              design_doc_name = File.basename(design_doc)

              # Load views from filesystem
              views = assemble_views(design_doc)

              # Load views from couchdb
              couchdb_design = db_con.get("_design/#{design_doc_name}")

              # Merge views: update couchdb existing views
              views = couchdb_design['views'].merge(views)

              if views.empty?
                result << "No updatable views in #{design_doc}/#{File.basename(design_doc)}"
              else
                db_con.save_doc({
                                  '_id' => "_design/#{design_doc_name}",
                                  '_rev' => couchdb_design['_rev'],
                                  'language' => 'javascript',
                                  'views' => views
                                })
                result << "Added views to _design/#{design_doc_name}: #{views.map {|k,v| k }.join(', ')}"
              end
            end
            puts "No views were found in '#{File.join(db,"views", view)}'" if result.empty?
          else
            return  "CouchDB database '#{db_name}' doesn't exist! Create it first."
          end
        else
          return "CouchDB database '#{database}' doesn't exist"
        end
        puts "#{result.join("\n")}"
      end
    end

    # Assemble views from file-system path design_doc_path
    def assemble_views(design_doc_path)
      views = {}

      Dir.glob(File.join(design_doc_path, '*')).each do |view_folder|
        view = {}
        map_file    = File.join(view_folder, 'map.js')
        reduce_file = File.join(view_folder, 'reduce.js')

        view[:map]    = IO.read(map_file)    if File.exist?(map_file)
        view[:reduce] = IO.read(reduce_file) if File.exist?(reduce_file) && File.size(reduce_file) > 0
        views[File.basename(view_folder)] = view if view[:map]
      end
      views
    end
  end
end
