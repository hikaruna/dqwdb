CREATE TABLE IF NOT EXISTS "zokusei" (
	"zokusei"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("zokusei")
) STRICT;
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
CREATE TABLE IF NOT EXISTS "kouka" (
	"kouka"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("kouka")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaihenka" (
	"zyoutaihenka"	TEXT NOT NULL,
	"order"	INT NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaihenka")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaihenka_group" (
	"zyoutaihenka_group"	TEXT NOT NULL,
	"order"	INT NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaihenka_group")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaihenka_group_zyoutaihenka" (
	"zyoutaihenka_group"	TEXT NOT NULL,
	"zyoutaihenka"	TEXT NOT NULL,
	PRIMARY KEY("zyoutaihenka_group","zyoutaihenka"),
	FOREIGN KEY("zyoutaihenka") REFERENCES "zyoutaihenka"("zyoutaihenka") ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY("zyoutaihenka_group") REFERENCES "zyoutaihenka_group"("zyoutaihenka_group") ON UPDATE RESTRICT ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaiizyou_group" (
	"zyoutaiizyou_group"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaiizyou_group")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaiizyou_group_zyoutaiizyou" (
	"zyoutaiizyou_group"	TEXT NOT NULL,
	"zyoutaiizyou"	TEXT NOT NULL,
	PRIMARY KEY("zyoutaiizyou_group","zyoutaiizyou"),
	FOREIGN KEY("zyoutaiizyou") REFERENCES "zyoutaiizyou"("zyoutaiizyou") ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY("zyoutaiizyou_group") REFERENCES "zyoutaiizyou_group"("zyoutaiizyou_group") ON UPDATE RESTRICT ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "skill_type" (
	"skill_type"	TEXT NOT NULL,
	PRIMARY KEY("skill_type")
) STRICT;
CREATE TABLE IF NOT EXISTS "soubi" (
	"soubi"	TEXT NOT NULL,
	"skill_tokusyukouka_text"	TEXT NOT NULL,
	PRIMARY KEY("soubi")
) STRICT;
