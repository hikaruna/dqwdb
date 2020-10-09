cat data.tsv |
sed 's/％/%/g' |
sed 's/ヒャド属性耐性7%/ヒャド属性耐性+7%/g' |
sed 's/スキルHP+回復効果/スキルHP回復効果/g' |
sed 's/ターン開始時\(HP\|MP\)+を/ターン開始時\1を/g' |
sed 's/\(ターン開始時\|戦闘終了時に\)\(HP\|MP\)を\([0-9]\+\)回復する/\1\2を回復する+\3/g' |
sed 's/コスト+/こころ最大コスト+/g' |
sed 's/スキルの斬撃・体技/スキルの斬撃体技/g' |
cat > normalization_data.tsv

cat normalization_data.tsv |
cut -f 15 |
sed 's/ /\n/g' |
sed 's/\(.*\)+[0-9]\+[％%]\?.*$/\1/' |
sort -u |
cat > effects.tsv

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

