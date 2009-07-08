require 'json'

module CouchRestRails
  module Lucene
    extend self

    # Push index/search views to CouchDB
    def push(database, design_doc)
      puts "database = #{database} :: design_doc = #{design_doc}"
      result = []

      db_dir = File.join(RAILS_ROOT, CouchRestRails.setup_path, database)
      return "Database '#{database}' does not exist" unless (database == "*" || File.exist?(db_dir))

      Dir[db_dir].each do |db|
        return "Lucene directory '#{db}/lucene' does not exist." unless File.exist?("#{db}/lucene")

        # CouchDB checks
        db_name = COUCHDB_CONFIG[:db_prefix] + File.basename(db) + COUCHDB_CONFIG[:db_suffix]
        begin
          CouchRest.get("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
        rescue => err
          return "CouchDB database '#{db_name}' does not exist. Create it first. (#{err})"
        end

        # Update CouchDB designs
        db_con = CouchRest.database("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
        Dir.glob(File.join(db, 'lucene', design_doc)).each do |doc|
          design_doc_name = File.basename(doc)

          # Load lucene definition views from FS
          index_views = assemble_lucene(doc)
          couchdb_design = db_con.get("_design/#{design_doc_name}") rescue nil

          # Update CouchDB's design with fulltext definition files
          if index_views.blank?
            result << "No search was found in #{doc}/#{design_doc_name}"
          else
            # Create the design doc, and/or update fulltext property
            couchdb_design = { '_id' => "_design/#{design_doc_name}" } if couchdb_design.nil?
            couchdb_design['fulltext'] = index_views

            db_con.save_doc(couchdb_design)
            result << "Added lucene fulltext views to #{design_doc_name}: #{index_views.keys.join(', ')}"
          end

        end
      end
      result.join("\n")
    end

    # Assemble views from file-system path lucene_doc_path
    def assemble_lucene(lucene_doc_path)
      search = {}
      Dir.glob(File.join(lucene_doc_path, '*')).each do |search_file|
        search_name = File.basename(search_file).sub(/\.js$/, '')
        search[search_name] = JSON.parse IO.read(search_file)
      end
      search
    end
  end
end
