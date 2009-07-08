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

        # Load lucene views from FS
        doc_path = File.join(db, 'lucene')
        index_views = assemble_lucene(doc_path)

        # Update CouchDB designs
        db_con = CouchRest.database("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
        if index_views.blank?
          result << "No search was found in #{doc_path}/#{File.basename(doc_path)}"
        else
          design_id = "_design/#{File.basename(doc_path)}"
          db_con.save_doc({ "_id" => design_id,
                            :fulltext => index_views
                          })
          result << "Added lucene-search the following design_doc to #{design_id}: #{index_views.keys.join(', ')}"
        end
      end
      result.join("\n")
    end

    # Assemble views from file-system path lucene_doc_path
    def assemble_lucene(lucene_doc_path)
      search = {}
      if File.exist?(File.join(lucene_doc_path, 'lucene.js'))
        lucene = {'defaults' => { 'store' => 'no', 'index' => 'not_analyzed' } }
        lucene['index'] = IO.read(File.join(lucene_doc_path, 'lucene.js')).gsub(/\n/, '')
        search['message_search'] = lucene
      end
      search
    end
  end
end
