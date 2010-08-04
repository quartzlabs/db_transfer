require 'rubygems'
require 'db_export'

#load database configuration
db_config=YAML::load_file("database.yml")

#create the export object
exporter=DbExport.new(db_config)

#dump all tables in db
exporter.dump

#or dump specific tables
#exporter.dump(:table1, :table2, :table3)