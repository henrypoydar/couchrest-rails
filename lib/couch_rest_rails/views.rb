module CouchRestRails
  module Views
  
    extend self

    def push
      
      return "Views directory (#{CouchRestRails.views_path}) does not exist" unless 
        File.exist?(File.join(RAILS_ROOT, CouchRestRails.views_path))
        
      views = assemble_views
      return "No views were found in #{CouchRestRails.views_path}" if views.empty?
      
      res = CouchRest.get(COUCHDB_SERVER[:instance]) rescue nil
      if res && res['db_name'] && res['db_name'] == COUCHDB_SERVER[:database]
        db = CouchRest.database(COUCHDB_SERVER[:instance])
        db.save_doc({
          "_id" => "_design/application", 
          :views => views
        })
        return "Pushed views to CouchDB database '#{COUCHDB_SERVER[:database]}'"
      else
        return "CouchDB database '#{COUCHDB_SERVER[:database]}' doesn't exist"
      end
      
    end
    
    def assemble_views
      views = {}
      Dir.glob(File.join(RAILS_ROOT, CouchRestRails.views_path, '*')).each do |view_folder|
        view = {}
        view[:map] = IO.read(File.join(view_folder, 'map.js')) if File.exist?(File.join(view_folder, 'map.js'))
        view[:reduce] = IO.read(File.join(view_folder, 'reduce.js')) if File.exist?(File.join(view_folder, 'reduce.js'))
        views[File.basename(view_folder).to_sym] = view if view[:map] 
      end
      views
    end
    

  end
end