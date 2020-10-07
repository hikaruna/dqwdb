cat data_header.tsv data.tsv |
jq -s -R '[split("\n")[]|select(length > 0)|split("\t")|map(gsub("^\\s+|\\s+$";""))]|.[0] as $header | .[1:]|map([ $header, . ]|transpose|map({"key": (.[0]//""), "value": (.[1]//"")})|from_entries)' |
sed '1s/^/export const data = /; $s/$/;/'
