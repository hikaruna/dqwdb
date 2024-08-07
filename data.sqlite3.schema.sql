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
