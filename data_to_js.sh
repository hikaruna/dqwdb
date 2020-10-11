./parser/normalize.sh data.tsv > normalization_data.tsv
./parser/parse_effects_tsv.sh normalization_data.tsv > effects.tsv

cat effects.tsv |
tr '\n' "\t" |
sed 's/\s$//' |
jq -RM 'split("\t")' |
sed '1s/^/export const effects = /; $s/$/;/' |
cat > effects.js

cat data_header.tsv |
tr '\n' "\t" |
sed 's/\s$//' |
jq -RM 'split("\t")' |
sed '1s/^/export const dataHeader = /; $s/$/;/' |
cat > data_header.js

cat data_header.tsv normalization_data.tsv |
jq -s -R '[split("\n")[]|select(length > 0)|split("\t")|map(gsub("^\\s+|\\s+$";""))]|.[0] as $header | .[1:]|map([ $header, . ]|transpose|map({"key": (.[0]//""), "value": (.[1]//"")})|from_entries)' |
jq ". | map(.+{ $(cat effects.tsv | sed 's/^\(.*\)$/"\1": 0,/' | tr '\n' ' ') })" |
cat > data.json

cat data.json |
sed '1s/^/export const data = /; $s/$/;/' |
cat > data.js

