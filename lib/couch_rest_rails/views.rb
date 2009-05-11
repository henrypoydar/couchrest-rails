module CouchRestRails
  module Views
  
    extend self

    def push
      
      return "Views directory (#{CouchRestRails.views_path}) does not exist" unless 
        File.exist?(File.join(RAILS_ROOT, CouchRestRails.views_path))
        
      res = CouchRest.get(COUCHDB_CONFIG[:full_path]) rescue nil
      if res && res['db_name'] && res['db_name'] == COUCHDB_CONFIG[:database]        
        
        result = []
        db = CouchRest.database(COUCHDB_CONFIG[:full_path])
        
        Dir.glob(File.join(RAILS_ROOT, CouchRestRails.views_path, '*')).each do |design_doc|
          design_doc_name = File.basename(design_doc)
          views = assemble_views(design_doc)
          if views.empty?
            result << "No views were found in #{CouchRestRails.views_path}/#{File.basename(design_doc)}" 
          else
            db.save_doc({
              "_id" => "_design/#{design_doc_name}", 
              :views => views
            })
            result << "Added views the following views to _design/#{design_doc_name}: #{views.map {|k,v| k.to_s}.join(', ')}"
          end
        end
        
        return "No views were found in #{CouchRestRails.views_path}" if result.empty?
        
      else
        return "CouchDB database '#{COUCHDB_CONFIG[:database]}' doesn't exist"
      end
      
      result.join("\n")
      
    end
    
    def assemble_views(design_doc_path)
      views = {}
      Dir.glob(File.join(design_doc_path, '*')).each do |view_folder|
        view = {}
        view[:map] = IO.read(File.join(view_folder, 'map.js')) if File.exist?(File.join(view_folder, 'map.js'))
        view[:reduce] = IO.read(File.join(view_folder, 'reduce.js')) if File.exist?(File.join(view_folder, 'reduce.js'))
        views[File.basename(view_folder).to_sym] = view if view[:map] 
      end
      views
    end
    

  end
end