cat <<EOS
BEGIN TRANSACTION;
DROP TABLE IF EXISTS "こころ";
CREATE TABLE IF NOT EXISTS "こころ" (
	"モンスター"	INTEGER NOT NULL UNIQUE,
	"グレード"	TEXT NOT NULL,
	"さいだいHP"	INTEGER NOT NULL,
	"さいだいMP"	INTEGER NOT NULL,
	"ちから"	INTEGER NOT NULL,
	"みのまもり"	INTEGER NOT NULL,
	"こうげき魔力"	INTEGER NOT NULL,
	"かいふく魔力"	INTEGER NOT NULL,
	"すばやさ"	INTEGER NOT NULL,
	"きようさ"	INTEGER NOT NULL,
	FOREIGN KEY("グレード") REFERENCES "グレード"("名前"),
	PRIMARY KEY("モンスター","グレード")
);
DROP TABLE IF EXISTS "こころの特殊効果";
CREATE TABLE IF NOT EXISTS "こころの特殊効果" (
	"こころ"	TEXT NOT NULL,
	"グレード"	TEXT NOT NULL,
	"特殊効果"	TEXT NOT NULL,
	"値"	INTEGER NOT NULL,
	FOREIGN KEY("特殊効果") REFERENCES "特殊効果"("名前"),
	FOREIGN KEY("こころ","グレード") REFERENCES "こころ"("モンスター","グレード"),
	PRIMARY KEY("こころ","グレード","特殊効果")
);
DROP TABLE IF EXISTS "特殊効果";
CREATE TABLE IF NOT EXISTS "特殊効果" (
	"名前"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("名前")
);
DROP TABLE IF EXISTS "グレード";
CREATE TABLE IF NOT EXISTS "グレード" (
	"名前"	TEXT NOT NULL,
	PRIMARY KEY("名前")
);
DROP VIEW IF EXISTS "こころview";
CREATE VIEW "こころview" AS SELECT \`こころ\`.*, \`特殊効果\`.\`名前\`,
CASE WHEN \`値\` IS NULL
THEN 0
ELSE \`値\`
END
AS \`値\`
 FROM \`特殊効果\`
 CROSS JOIN \`こころ\`
 LEFT OUTER JOIN \`こころの特殊効果\` ON
  \`こころの特殊効果\`.\`こころ\` = \`こころ\`.\`モンスター\`
  AND
  \`こころの特殊効果\`.\`グレード\` = \`こころ\`.\`グレード\`
  AND
  \`こころの特殊効果\`.\`特殊効果\` = \`特殊効果\`.\`名前\`
ORDER BY \`こころ\`.rowid;
EOS


echo 'DROP VIEW IF EXISTS "こころPivotView";'
echo 'CREATE VIEW "こころPivotView" AS '
$(dirname $0)/parse_effects_tsv_to_minds_pivot_sql.sh effects.tsv

echo 'COMMIT;'
