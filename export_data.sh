sqlite3 data.sqlite3 <<!  > data.sqlite3.schema.sql
.load ./pivotvtab 
.load ./regexp 
.schema
!
$(dirname $0)/sqlite2csv.sh data.sqlite3
