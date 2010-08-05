require 'active_record'

class DbTransfer 

  def initialize(db_config,path=nil)
    ActiveRecord::Base.establish_connection(db_config)
    @path = (path || ".") + "/"
  end
  
  def export(*tables)
    for_each_table_in tables, :_export
  end
  
  def import(*tables)
    for_each_table_in tables, :_import
  end
  
  def empty(*tables)
    for_each_table_in tables, :_empty
  end
  
  def count(*tables)
    for_each_table_in tables, :_count
  end
  
  private
  
  def for_each_table_in(tables, method)
    tables = ActiveRecord::Base.connection.tables if tables.empty? 
  
    tables.each do |table|
      print "#{method.to_s[1..-1]} #{table}..."
      @model=Class.new(ActiveRecord::Base)
      @model.set_table_name(table)
      n = send(method, table)
      puts n.to_s
    end
  end

  def _export(table)
    records=nil
    File.open("#{@path}/#{table}.yml", "w") do |f|
      records =  @model.all.map {|record| record.attributes}
      f.write records.to_yaml
    end
    records.length
  end  
  
  def _import(table)
    records = YAML::load_file("#{@path}/#{table}.yml")
    records.each do |record|
      instance_of_model=@model.new
      instance_of_model.send(:attributes=, record, false)
      instance_of_model.save
    end
    _count(table)
  end
  
  def _empty(table)
    @model.delete_all
    _count(table)
  end
  
  def _count(table)
    @model.all.length
  end
  
end

