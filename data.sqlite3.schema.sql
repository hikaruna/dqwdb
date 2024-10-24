CREATE TABLE IF NOT EXISTS "bougu" (
	"item"	TEXT NOT NULL,
	"type"	TEXT NOT NULL,
	PRIMARY KEY("item"),
	FOREIGN KEY("item") REFERENCES "item"("item") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("type") REFERENCES "bougu_type"("bougu_type") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "bougu_type" (
	"bougu_type"	TEXT NOT NULL,
	PRIMARY KEY("bougu_type")
) STRICT;
CREATE TABLE IF NOT EXISTS "genkaitoppa_level" (
	"genkaitoppa_level"	INTEGER NOT NULL,
	PRIMARY KEY("genkaitoppa_level")
) STRICT;
CREATE TABLE IF NOT EXISTS "item" (
	"item"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL,
	"type"	TEXT NOT NULL,
	"rarity"	INTEGER NOT NULL,
	PRIMARY KEY("item"),
	FOREIGN KEY("rarity") REFERENCES "item_rarity"("item_rarity") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("type") REFERENCES "item_type"("item_type") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "item_rarity" (
	"item_rarity"	INTEGER NOT NULL,
	PRIMARY KEY("item_rarity")
) STRICT;
CREATE TABLE IF NOT EXISTS "item_type" (
	"item_type"	TEXT NOT NULL,
	PRIMARY KEY("item_type")
) STRICT;
CREATE TABLE IF NOT EXISTS "rensei_level" (
	"rensei_level"	INTEGER NOT NULL,
	PRIMARY KEY("rensei_level")
) STRICT;
CREATE TABLE IF NOT EXISTS "skill_tokusyukouka" (
	"skill_tokusyukouka"	TEXT NOT NULL,
	PRIMARY KEY("skill_tokusyukouka")
) STRICT;
CREATE TABLE IF NOT EXISTS "skill" (
	"skill"	TEXT NOT NULL,
	PRIMARY KEY("skill"),
	FOREIGN KEY("skill") REFERENCES "skill_tokusyukouka"("skill_tokusyukouka") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "tokusyukouka" (
	"tokusyukouka"	TEXT NOT NULL,
	PRIMARY KEY("tokusyukouka"),
	FOREIGN KEY("tokusyukouka") REFERENCES "skill_tokusyukouka"("skill_tokusyukouka") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "item_skill_tokusyukouka" (
	"item"	TEXT NOT NULL,
	"skill_tokusyukouka"	TEXT NOT NULL,
	"hosei_per"	INTEGER,
	"hosei_value"	INTEGER,
	"kougekizi_no_kakuritu_hosei"	INTEGER,
	"hanekaesu_kakuritu_hosei"	INTEGER,
	"tern_kaisizi_sentou_syuuryouzi"	INTEGER,
	"condition"	TEXT,
	"genkaitoppa"	INTEGER,
	"rensei"	INTEGER,
	FOREIGN KEY("genkaitoppa") REFERENCES "genkaitoppa_level"("genkaitoppa_level") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("item") REFERENCES "item"("item") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("rensei") REFERENCES "rensei_level"("rensei_level") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("skill_tokusyukouka") REFERENCES "skill_tokusyukouka"("skill_tokusyukouka") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "zokusei" (
	"zokusei"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("zokusei")
) STRICT;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE sqlite_stat4(tbl,idx,neq,nlt,ndlt,sample);
CREATE TABLE IF NOT EXISTS "keitou" (
	"keitou"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("keitou")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaiizyou" (
	"zyoutaiizyou"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaiizyou")
) STRICT;
CREATE TABLE IF NOT EXISTS "kokoro" (
	"no"	INTEGER NOT NULL UNIQUE,
	"kokoro"	TEXT NOT NULL,
	"cost"	INTEGER NOT NULL,
	"keitou"	TEXT,
	PRIMARY KEY("kokoro"),
	FOREIGN KEY("keitou") REFERENCES "keitou"("keitou") ON UPDATE CASCADE ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "kokoro_grade" (
	"kokoro_grade"	TEXT NOT NULL UNIQUE,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("kokoro_grade")
);
CREATE VIRTUAL TABLE v_item USING pivot_vtab (
  -- ROWS
  (SELECT DISTINCT item from item),
  (SELECT DISTINCT zokusei, zokusei FROM zokusei),
  (SELECT 'null')
);
CREATE TABLE sqlean_define(name text primary key, type text, body text);
CREATE VIEW v_item_skill_tokusyukouka AS
  SELECT * FROM item
  JOIN item_skill_tokusyukouka
  ON item.item = item_skill_tokusyukouka.item
/* v_item_skill_tokusyukouka(item,"order",type,rarity,"item:1",skill_tokusyukouka,hosei_per,hosei_value,kougekizi_no_kakuritu_hosei,hanekaesu_kakuritu_hosei,tern_kaisizi_sentou_syuuryouzi,condition,genkaitoppa,rensei) */;
CREATE TABLE IF NOT EXISTS "skill_type" (
	"skill_type"	TEXT NOT NULL,
	PRIMARY KEY("skill_type")
);
CREATE TABLE IF NOT EXISTS "tokusyukouka_target_skill_type" (
	"tokusyukouka_target_skill_type"	TEXT NOT NULL,
	"skill_type"	TEXT NOT NULL,
	PRIMARY KEY("tokusyukouka_target_skill_type"),
	FOREIGN KEY("skill_type") REFERENCES "skill_type"("skill_type") ON UPDATE RESTRICT ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS "zokusei_type" (
	"zokusei_type"	TEXT NOT NULL,
	PRIMARY KEY("zokusei_type")
);
CREATE TABLE IF NOT EXISTS "tokusyukouka_target_zokusei_type" (
	"tokusyukouka_target_zokusei_type"	TEXT NOT NULL,
	"zokusei_type"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("tokusyukouka_target_zokusei_type"),
	FOREIGN KEY("zokusei_type") REFERENCES "zokusei_type"("zokusei_type") ON UPDATE RESTRICT ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS "zokusei_type_zokusei" (
	"zokusei_type"	TEXT NOT NULL,
	"zokusei"	TEXT NOT NULL,
	PRIMARY KEY("zokusei_type","zokusei"),
	FOREIGN KEY("zokusei") REFERENCES "zokusei"("zokusei") ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY("zokusei_type") REFERENCES "zokusei_type"("zokusei_type") ON UPDATE RESTRICT ON DELETE RESTRICT
);
CREATE VIEW damage_hosei_tokusyukouka_zokusei AS
SELECT
  (
    (
	  CASE
		WHEN tokusyukouka_target_zokusei_type <> '' THEN tokusyukouka_target_zokusei_type||'属性'
		ELSE ''
	  END
	)||tokusyukouka_target_skill_type.tokusyukouka_target_skill_type||'ダメージ') as tokusyukouka
  ,zokusei_type_zokusei.zokusei
FROM tokusyukouka_target_zokusei_type
CROSS JOIN tokusyukouka_target_skill_type
LEFT OUTER JOIN zokusei_type_zokusei ON tokusyukouka_target_zokusei_type.zokusei_type = zokusei_type_zokusei.zokusei_type
WHERE tokusyukouka_target_zokusei_type <> '' OR tokusyukouka_target_skill_type <> ''
/* damage_hosei_tokusyukouka_zokusei(tokusyukouka,zokusei) */;
