module CouchRestRails
  module Lucene

    extend self

    def push(database, design_doc)
      result = []
      puts "database = #{database} :: design_doc=#{design_doc}"

      return  "Database '#{database}' doesn't exists" unless (database == "*" ||
                                                              File.exist?(File.join(RAILS_ROOT,
                                                                                    CouchRestRails.setup_path,
                                                                                    database)))
      Dir[File.join(RAILS_ROOT, CouchRestRails.setup_path, database)].each do |db|
        # check for a directory...
        if File::directory?(db)
          if File.exist?("#{db}/lucene")
            db_name =COUCHDB_CONFIG[:db_prefix] +  File.basename( db) +
              COUCHDB_CONFIG[:db_suffix]
            res = CouchRest.get("#{COUCHDB_CONFIG[:host_path]}/#{db_name}") rescue nil
            if res
              db_con = CouchRest.database("#{COUCHDB_CONFIG[:host_path]}/#{db_name}")
              doc = File.join(db,"lucene")
              design_doc_name = File.basename(doc)
              search = assemble_lucene(doc)
              if search.blank?
                result << "No search was found in #{doc}/#{File.basename(doc)}"
              else
                db_con.save_doc({ "_id" => "_design/#{design_doc_name}",
                                  :fulltext => search
                                })
                result << "Added lucene-search the following design_doc to _design/#{design_doc_name}: #{search.map {|k,v| k.to_s}.join(', ')}"
              end
            else
              return  "CouchDB database '#{db_name}' doesn't exist. create it first"
            end
          else
            puts "lucene directory (#{db}/lucence) does not exist"
          end
        else
          return "CouchDB database '#{database}' doesn't exist"
        end
      end
      result.join("\n")
    end

    def assemble_lucene(lucene_doc_path)
      search = {}
      if File.exist?(File.join(lucene_doc_path, 'lucene.js'))
        defaults = {"store" => "no", "index"=>"not_analyzed"}
        lucene = {"defaults" =>  defaults}
        lucene["index"] = IO.read(File.join(lucene_doc_path, 'lucene.js')).gsub(/\n/,"")
        search["message_search"] = lucene
      end
      search
    end
  end
end
