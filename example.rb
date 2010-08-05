require 'rubygems'
require 'db_transfer'

#load database configuration
db_config=YAML::load_file("database.yml")

#create the export object
db=DbTransfer.new(db_config,"dump")

#dump all tables in db

db.export

#empty all records in specified tables 
db.empty

#import yaml into db
db.import


# or export/import/empty specific tables
#  db.export(:table1, :table2, :table3)
#  db.empty(:table1)
#  db.import(:table1, :table2, :table3, :tableN)