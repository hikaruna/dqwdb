cat "$1" |
cut -f 15 |
sed 's/ /\n/g' |
sed 's/\(.*\)+[0-9]\+[％%]\?.*$/\1/' |
sort -u |
cat
