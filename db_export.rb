require 'active_record'

class DbExport 

  def initialize(db_config)
    ActiveRecord::Base.establish_connection(db_config)
  end
      
  def dump(*tables)
    tables = ActiveRecord::Base.connection.tables if tables.empty?
    
    tables.each do |table|
      @model=Class.new(ActiveRecord::Base)
      @model.set_table_name(table)
      print "Writing out data for #{table}..."
      File.open("#{table}.yml", "w") do |f|
        records =  @model.all.map {|record| record.attributes}
        f.write records.to_yaml
        puts "#{records.length}"
      end
    end
    
  end
    
end

