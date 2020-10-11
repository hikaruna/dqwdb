cat "$1" |
while read line
do
    echo "INSERT INTO \"特殊効果\" (\"名前\") VALUES ('${line}');"
done
