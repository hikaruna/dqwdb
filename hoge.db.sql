BEGIN TRANSACTION;
DROP TABLE IF EXISTS "skill_types";
CREATE TABLE IF NOT EXISTS "skill_types" (
	"name"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
DROP TABLE IF EXISTS "こころ";
CREATE TABLE IF NOT EXISTS "こころ" (
	"no"	INTEGER NOT NULL,
	"モンスター"	TEXT NOT NULL,
	"コスト"	INTEGER NOT NULL,
	"力"	INTEGER NOT NULL,
	"みのまもり"	INTEGER NOT NULL,
	"HP"	INTEGER NOT NULL,
	"MP"	INTEGER NOT NULL,
	"こうげき魔力"	INTEGER NOT NULL,
	"かいふく魔力"	INTEGER NOT NULL,
	"きようさ"	INTEGER NOT NULL,
	PRIMARY KEY("no")
);
DROP TABLE IF EXISTS "種族";
CREATE TABLE IF NOT EXISTS "種族" (
	"name"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
DROP TABLE IF EXISTS "elements";
CREATE TABLE IF NOT EXISTS "elements" (
	"name"	TEXT NOT NULL,
	PRIMARY KEY("name")
);
DROP TABLE IF EXISTS "攻撃補正効果";
CREATE TABLE IF NOT EXISTS "攻撃補正効果" (
	"skill_type"	TEXT,
	"element"	TEXT,
	"種族"	TEXT,
	"id"	INTEGER NOT NULL,
	FOREIGN KEY("種族") REFERENCES "種族"("name"),
	FOREIGN KEY("id") REFERENCES "効果"("id"),
	FOREIGN KEY("element") REFERENCES "elements"("name"),
	FOREIGN KEY("skill_type") REFERENCES "skill_types"("name"),
	PRIMARY KEY("id"),
	UNIQUE("skill_type","element","種族")
);
DROP TABLE IF EXISTS "効果";
CREATE TABLE IF NOT EXISTS "効果" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id")
);
DROP TABLE IF EXISTS "ステータス増加効果";
CREATE TABLE IF NOT EXISTS "ステータス増加効果" (
	"id"	INTEGER NOT NULL,
	FOREIGN KEY("id") REFERENCES "効果"("id"),
	PRIMARY KEY("id")
);
DROP TABLE IF EXISTS "状態異常";
CREATE TABLE IF NOT EXISTS "状態異常" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "状態異常耐性効果";
CREATE TABLE IF NOT EXISTS "状態異常耐性効果" (
	"id"	INTEGER NOT NULL,
	"状態異常_id"	INTEGER NOT NULL,
	FOREIGN KEY("状態異常_id") REFERENCES "状態異常"("id"),
	FOREIGN KEY("id") REFERENCES "効果"("id"),
	PRIMARY KEY("id")
);
DROP TABLE IF EXISTS "こころ効果";
CREATE TABLE IF NOT EXISTS "こころ効果" (
	"id"	INTEGER NOT NULL,
	"こころ_no"	INTEGER NOT NULL,
	"効果_id"	INTEGER NOT NULL,
	FOREIGN KEY("こころ_no") REFERENCES "こころ"("no"),
	FOREIGN KEY("効果_id") REFERENCES "効果"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);
DROP TABLE IF EXISTS "ステータス増加効果値";
CREATE TABLE IF NOT EXISTS "ステータス増加効果値" (
	"ステータス増加効果_id"	INTEGER NOT NULL,
	"value"	INTEGER NOT NULL,
	"こころ効果_id"	INTEGER NOT NULL,
	FOREIGN KEY("ステータス増加効果_id") REFERENCES "ステータス増加効果"("id"),
	FOREIGN KEY("こころ効果_id") REFERENCES "こころ効果"("id"),
	PRIMARY KEY("こころ効果_id")
);
DROP TABLE IF EXISTS "攻撃補正効果値";
CREATE TABLE IF NOT EXISTS "攻撃補正効果値" (
	"攻撃補正効果_id"	INTEGER NOT NULL,
	"value"	INTEGER NOT NULL,
	"こころ効果_id"	INTEGER NOT NULL,
	FOREIGN KEY("攻撃補正効果_id") REFERENCES "攻撃補正効果"("id"),
	PRIMARY KEY("こころ効果_id")
);
DROP TABLE IF EXISTS "状態異常耐性効果値";
CREATE TABLE IF NOT EXISTS "状態異常耐性効果値" (
	"こころ効果_id"	INTEGER NOT NULL,
	"状態異常耐性効果_id"	INTEGER NOT NULL,
	"value"	INTEGER NOT NULL,
	FOREIGN KEY("こころ効果_id") REFERENCES "こころ効果"("id"),
	FOREIGN KEY("状態異常耐性効果_id") REFERENCES "状態異常耐性効果"("id"),
	PRIMARY KEY("こころ効果_id")
);
INSERT INTO "skill_types" ("name") VALUES ('体技'),
 ('じゅもん'),
 ('ブレス'),
 ('斬撃');
INSERT INTO "こころ" ("no","モンスター","コスト","力","みのまもり","HP","MP","こうげき魔力","かいふく魔力","きようさ") VALUES (446,'バリクナジャ',0,0,0,0,0,0,0,0);
INSERT INTO "種族" ("name") VALUES ('スライム'),
 ('けもの'),
 ('ドラゴン');
INSERT INTO "elements" ("name") VALUES ('メラ'),
 ('ギラ'),
 ('イオ'),
 ('バギ'),
 ('ジバリア'),
 ('ドルマ'),
 ('ヒャド'),
 ('デイン');
INSERT INTO "攻撃補正効果" ("skill_type","element","種族","id") VALUES ('斬撃',NULL,NULL,2),
 (NULL,NULL,'ドラゴン',3);
INSERT INTO "効果" ("id","name") VALUES (1,'こころ最大コスト+'),
 (2,'スキルの斬撃ダメージ+'),
 (3,'ドラゴン系へのダメージ+'),
 (4,'麻痺耐性+');
INSERT INTO "ステータス増加効果" ("id") VALUES (1);
INSERT INTO "状態異常" ("id","name") VALUES (1,'毒'),
 (2,'麻痺');
INSERT INTO "状態異常耐性効果" ("id","状態異常_id") VALUES (4,2);
INSERT INTO "こころ効果" ("id","こころ_no","効果_id") VALUES (1,446,1),
 (2,446,2),
 (3,446,3),
 (4,446,4);
INSERT INTO "ステータス増加効果値" ("ステータス増加効果_id","value","こころ効果_id") VALUES (1,4,1);
INSERT INTO "攻撃補正効果値" ("攻撃補正効果_id","value","こころ効果_id") VALUES (2,3,2),
 (3,10,3);
INSERT INTO "状態異常耐性効果値" ("こころ効果_id","状態異常耐性効果_id","value") VALUES (4,4,5);
DROP VIEW IF EXISTS "攻撃補正条件";
CREATE VIEW "攻撃補正条件" AS SELECT * FROM
  (
	SELECT * FROM skill_types UNION SELECT NULL
  )
  CROSS JOIN
  (
	SELECT * FROM elements UNION SELECT NULL
  )
    CROSS JOIN
  (
	SELECT * FROM `種族` UNION SELECT NULL
  );
DROP VIEW IF EXISTS "効果データ";
CREATE VIEW "効果データ" AS SELECT
 no AS `こころ_no`,
 `効果`.name AS `効果`,
 `攻撃補正効果`.skill_type,
 `攻撃補正効果`.element,
 `攻撃補正効果`.`種族`,
 `状態異常`.name AS `状態異常`,
 `攻撃補正効果値`.value AS `攻撃補正値`,
 `ステータス増加効果値`.value AS `ステータス増加値`,
 `状態異常耐性効果値`.value AS `状態異常耐性効果値`
FROM `こころ`
INNER JOIN `こころ効果` ON `こころ_no` = no
INNER JOIN `効果` ON `効果_id` = `効果`.id
LEFT OUTER JOIN `攻撃補正効果` ON `攻撃補正効果`.id = `効果`.id
LEFT OUTER JOIN `攻撃補正効果値` ON `攻撃補正効果値`.`こころ効果_id` = `こころ効果`.id
LEFT OUTER JOIN `ステータス増加効果` ON `ステータス増加効果`.id = `効果`.id
LEFT OUTER JOIN `ステータス増加効果値` ON `ステータス増加効果値`.`こころ効果_id` = `こころ効果`.id
LEFT OUTER JOIN `状態異常耐性効果` ON `状態異常耐性効果`.id = `効果`.id
LEFT OUTER JOIN `状態異常` ON `状態異常`.id = `状態異常耐性効果`.`状態異常_id`
LEFT OUTER JOIN `状態異常耐性効果値` ON `状態異常耐性効果値`.`こころ効果_id` = `こころ効果`.id;
COMMIT;
