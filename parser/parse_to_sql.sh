$(dirname $0)/normalize.sh data.tsv > normalization_data.tsv
$(dirname $0)/parse_effects_tsv.sh normalization_data.tsv > effects.tsv

echo 'BEGIN TRANSACTION;'
echo 'INSERT INTO "グレード" ("名前") VALUES ("S");'
echo 'INSERT INTO "グレード" ("名前") VALUES ("A");'
echo 'INSERT INTO "グレード" ("名前") VALUES ("B");'
echo 'INSERT INTO "グレード" ("名前") VALUES ("C");'
echo 'INSERT INTO "グレード" ("名前") VALUES ("D");'
$(dirname $0)/parse_effects_tsv_to_sql.sh effects.tsv
$(dirname $0)/parse_minds_tsv_to_sql.sh normalization_data.tsv
$(dirname $0)/parse_mind_effects_tsv_to_sql.rb normalization_data.tsv
echo 'COMMIT;'
