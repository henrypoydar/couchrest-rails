module CouchRestRails
  module Views
    extend self

    # Push views to couchdb
    def push(database_name = '*', view_name = '*')
      
      CouchRestRails.process_database_method(database_name) do |db, response|
        
        full_db_name = [COUCHDB_CONFIG[:db_prefix], File.basename(db), COUCHDB_CONFIG[:db_suffix]].join
        full_db_path = [COUCHDB_CONFIG[:host_path], '/', full_db_name].join
        
        # Check for CouchDB database
        if !COUCHDB_SERVER.databases.include?(full_db_name)
          response << "Database #{db} (#{full_db_name}) does not exist"
          next
        end
        
        # Check for views directory
        unless File.exist?(File.join(RAILS_ROOT, CouchRestRails.views_path, db))
          response << "Views directory (#{CouchRestRails.views_path}/#{db}) does not exist" 
          next
        end
        
        # Assemble views for each design doc
        db_conn = CouchRest.database(full_db_path)
        views = {}
        Dir.glob(File.join(RAILS_ROOT, CouchRestRails.views_path, db, "views", view_name)).each do |doc|
          
          # Load views from filesystem 
          view = assemble_view(doc)
          if view.empty?
            response << "No view files were found in #{CouchRestRails.views_path}/#{db}/views/#{File.basename(doc)}" 
            next
          else
            views[File.basename(doc)] = view
          end

          # Load views from Couch
          couchdb_views = db_conn.get("_design/#{design_doc_name}") rescue nil

          # Warn if overwriting views on Couch 
          # merge!
            
          end
        end
        
        # Do the save
        
        # begin
        #   existing_doc = db_conn.get("_design/#{design_doc_name}")
        #   if existing_doc
        #     response << "WARINING: overwriting _design/#{design_doc_name}"
        #     db_conn.delete_doc(existing_doc)
        #   end
        # rescue
        # end

        # db_conn.save_doc({
        #           "_id" => "_design/#{full_db_name}", 
        #           'language' => 'javascript',
        #           :views => views
        #         })
        #         response << "Pushed views to #{full_db_name}/_design/#{full_db_name}"
        
      end
    
    end

    # Assemble views 
    def assemble_view(design_doc_path)
      view = {}
      map_file    = File.join(design_doc_path, 'map.js')
      reduce_file = File.join(design_doc_path, 'reduce.js')
      view[:map]    = IO.read(map_file)    if File.exist?(map_file)
      view[:reduce] = IO.read(reduce_file) if File.exist?(reduce_file) && File.size(reduce_file) > 0
      view
    end
    
  end
end
