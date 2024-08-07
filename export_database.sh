sqlite3 data.sqlite3 '.schema' > data.sqlite3.schema.sql
$(dirname $0)/sqlite2csv.sh data.sqlite3
