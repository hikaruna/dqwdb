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
)
/* v_item(item,"イオ","ギラ","ザバ","ジバリア","デイン","ドルマ","バギ","ヒャド","メラ") */;
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
CREATE TABLE IF NOT EXISTS "soubi" (
	"soubi"	TEXT NOT NULL,
	"skill_tokusyukouka_text"	TEXT NOT NULL,
	PRIMARY KEY("soubi")
);
CREATE VIEW damage_hosei_tokusyukouka_zokusei AS
SELECT
  (
    (
	  CASE
		WHEN tokusyukouka_target_zokusei_type <> '' THEN tokusyukouka_target_zokusei_type||'属性'
		WHEN tokusyukouka_target_skill_type = 'じゅもん' THEN ''
		ELSE 'スキルの'||tokusyukouka_target_zokusei_type
	  END
	)||tokusyukouka_target_skill_type.tokusyukouka_target_skill_type||'ダメージ') as tokusyukouka
  ,zokusei_type_zokusei.zokusei
FROM tokusyukouka_target_zokusei_type
CROSS JOIN tokusyukouka_target_skill_type
LEFT OUTER JOIN zokusei_type_zokusei ON tokusyukouka_target_zokusei_type.zokusei_type = zokusei_type_zokusei.zokusei_type
WHERE tokusyukouka_target_zokusei_type <> '' OR tokusyukouka_target_skill_type <> ''
/* damage_hosei_tokusyukouka_zokusei(tokusyukouka,zokusei) */;
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
CREATE VIEW tokusyukouka_variation AS

WITH
category_zyoutaiizyou AS (
SELECT zyoutaiizyou
FROM zyoutaiizyou
UNION ALL
SELECT '全状態異常'
)
,
 category_zokusei AS (
 SELECT zokusei
FROM zokusei
UNION ALL
SELECT '全' AS zokusei
 )
,
 table_a AS (
SELECT keitou as a
, 'keitou' AS category
FROM keitou

UNION ALL
SELECT zyoutaiizyou as a
, 'zyoutaiizyou' AS category
FROM category_zyoutaiizyou

UNION ALL
SELECT zyoutaihenka_group as a
, 'zyoutaihenka' AS category
FROM zyoutaihenka_group


UNION ALL
SELECT zokusei AS a
, 'zokusei' AS category
FROM category_zokusei

UNION ALL
SELECT '' AS a
, '' AS category
)
,
 table_b AS (
SELECT kouka FROM kouka
)
,
table_c AS (
SELECT * FROM skill_type
UNION ALL
SELECT ''
)
,
table_cross AS (
SELECT * FROM table_a
CROSS JOIN table_b
CROSS JOIN table_c

WHERE NOT(
 category = 'keitou' AND (
   kouka NOT IN('ダメージアップ','耐性')
   OR
   skill_type != ''
 )
 OR
 category = 'zyoutaiizyou' AND (
   kouka NOT IN('成功率','耐性')
   OR
   skill_type != ''
 )
 OR
 category = 'zyoutaihenka' AND (
   kouka NOT IN('成功率','耐性')
   OR
   skill_type != ''
   OR
   ( a = '一部の状態変化' AND kouka = '耐性' )
   OR
   ( a = '悪状態変化' AND kouka = '成功率' )
 )
 OR
 category = 'zokusei' AND (
   kouka NOT IN('ダメージアップ','耐性')
   OR
   skill_type IN('とくぎ')
 )
 OR
 kouka = 'HP回復' AND (
  skill_type NOT IN('スキル','じゅもん','とくぎ')
 )
 OR
 skill_type = 'とくぎ' AND kouka != 'HP回復'
 OR
 kouka = '成功率' AND category NOT IN('zyoutaiizyou','zyoutaihenka')
 OR
 category = '' AND (
  kouka IN('ダメージアップ','耐性') AND skill_type IN('スキル','とくぎ','')
 )
)
)


SELECT *
,
CASE a
 WHEN '全状態異常' THEN 'すべての状態異常'
 WHEN '悪状態変化' THEN '悪い状態変化'
 ELSE a END
||CASE category
    WHEN 'keitou' THEN 'への'
    WHEN 'zokusei' THEN '属性'
	ELSE '' END
||CASE category = '' AND kouka = 'ダメージアップ' AND skill_type IN('斬撃・体技','斬撃','体技','斬撃・体技・ブレス') WHEN 1 THEN 'スキルの' ELSE '' END
||skill_type
||CASE kouka
    WHEN 'ダメージアップ' THEN 'ダメージ'
    WHEN 'HP回復' THEN 'HP回復効果'
	ELSE kouka END
AS tokusyukouka
FROM table_cross
order by category
/* tokusyukouka_variation(a,category,kouka,skill_type,tokusyukouka) */;
CREATE VIEW soubi_skill_tokusyukouka_intermate AS


WITH RECURSIVE split(soubi,idx,fld,remain) AS (
WITH
 kousei_filtered AS (
 SELECT
  soubi
  , replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
    replace(
	regexp_replace(
	regexp_replace(
	  skill_tokusyukouka_text
	,'(スライム系|けもの系|ドラゴン系|虫系|鳥系|植物系|物質系|マシン系|ゾンビ系|悪魔系|エレメント系|怪人系|水系|\?\?\?\?系)(ダメージ|耐性)','$1への$2')
	,'(?:^|\n)スキルのHP回復効果','スキルHP回復効果')
	,'？？？？', '????')
	, '＋', '+')
	, '％', '%')
	, '０', '0')
	, '１', '1')
	, '２', '2')
	, '３', '3')
	, '４', '4')
	, '５', '5')
	, '６', '6')
	, '７', '7')
	, '８', '8')
	, '９', '9')
	, '擊', '撃')
	, '―', 'ー')
	, '練成', '錬成')
	, '特別演出開放', '特別演出解放')
	, '付与する', '与える')
	, '（', '(')
	, '）', ')')
	, 'とくぎダメージ', '斬撃・体技ダメージ')
	, 'ずべて', 'すべて')
   AS val
 FROM soubi
)


SELECT
  soubi
  , instr(val,char(10)) as idx
  ,substr(val,1,instr(val,char(10))-1) as fld
  ,substr(val,instr(val,char(10))+1)||char(10) as remain
FROM kousei_filtered

UNION ALL SELECT
  soubi
  , instr(remain,char(10)) as idx
  ,substr(remain,1,instr(remain,char(10))-1) as fld
  ,substr(remain,instr(remain,char(10))+1) as remain
FROM split
WHERE remain != ''
)

SELECT
 soubi
 , fld AS skill_tokusyukouka_intermate
FROM split
/* soubi_skill_tokusyukouka_intermate(soubi,skill_tokusyukouka_intermate) */;
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
CREATE VIEW soubi_skill_tokusyukouka AS
WITH
 genkaitoppa_unwrap AS (
 SELECT
  soubi
  , skill_tokusyukouka_intermate
  , regexp_capture(skill_tokusyukouka_intermate, '^(?:↑[1-4]:)?(.*)', 1) AS genkaitoppa_unwrap
  , regexp_capture(skill_tokusyukouka_intermate, '^↑([1-4]):', 1) AS genkaitoppa_level
 FROM soubi_skill_tokusyukouka_intermate
 )
 
  , condition_unwrap AS (
  SELECT
   soubi
   , skill_tokusyukouka_intermate
   , genkaitoppa_unwrap
   , regexp_capture(genkaitoppa_unwrap, '(.*?)(?:【.+?】)*$', 1) AS condition_unwrap
   , regexp_capture(genkaitoppa_unwrap, '(?:【.+?】)*$') AS condition
   , genkaitoppa_level
   FROM genkaitoppa_unwrap
  )
 
 ,hosei_unwrap AS (
 SELECT
  soubi
  , skill_tokusyukouka_intermate
  , genkaitoppa_unwrap
  , condition_unwrap
  , regexp_capture(condition_unwrap, '(.*?)(?:[\+-]\d+)%$',1) AS hosei_unwrap
  , CAST(regexp_capture(condition_unwrap, '([\+-]\d+)%$', 1) as INTEGER) AS hosei_per
  , NULL AS hosei_value
  , condition
  , genkaitoppa_level
 FROM condition_unwrap
 WHERE condition_unwrap REGEXP '[\+-]\d+%$'
 UNION ALL
  SELECT
  soubi
  , skill_tokusyukouka_intermate
  , genkaitoppa_unwrap
  , condition_unwrap
  , regexp_capture(condition_unwrap, '(.*?)(?:[\+-]\d+)$',1) AS hosei_unwrap
  , NULL AS hosei_per
  , CAST(regexp_capture(condition_unwrap, '([\+-]\d+)$', 1) as INTEGER) AS hosei_value
  , condition
  , genkaitoppa_level
 FROM condition_unwrap
 WHERE condition_unwrap REGEXP '[\+-]\d+$'
 UNION ALL
  SELECT
  soubi
  , skill_tokusyukouka_intermate
  , genkaitoppa_unwrap
  , condition_unwrap
  , condition_unwrap AS hosei_unwrap
  , NULL AS hosei_per
  , NULL AS hosei_value
  , condition
  , genkaitoppa_level
 FROM condition_unwrap
 WHERE condition_unwrap NOT REGEXP '[\+-]\d+%?$'
 
)

 ,for_debugg AS (
  SELECT
   soubi
   , skill_tokusyukouka_intermate
   , genkaitoppa_unwrap
   , condition_unwrap
   , hosei_unwrap
   , hosei_per
   , hosei_value
   , condition
   , genkaitoppa_level
  FROM hosei_unwrap
 )
/*SELECT * FROM for_debugg*/

SELECT
 soubi
 , hosei_unwrap AS skill_tokusyukouka
 , hosei_per
 , hosei_value
 , condition
 , genkaitoppa_level

 FROM for_debugg
 order by soubi
/* soubi_skill_tokusyukouka(soubi,skill_tokusyukouka,hosei_per,hosei_value,condition,genkaitoppa_level) */;
CREATE VIEW soubi_hosei AS

WITH zyoutaiizyou_kouka AS (
SELECT * FROM kouka
WHERE kouka IN('成功率','耐性')
)
,
zyoutaiizyou_variation AS (
SELECT CASE zyoutaiizyou_group
WHEN '全状態異常' THEN 'ずべての状態異常'
ELSE zyoutaiizyou_group
END||kouka AS tokusyukouka
, zyoutaiizyou_kouka.`order` AS kouka_order
, zyoutaiizyou_group.`order` AS zyoutaiizyou_order
FROM zyoutaiizyou_group
CROSS JOIN zyoutaiizyou_kouka
)
,
table_a AS (
SELECT soubi
, skill_tokusyukouka
, sum(hosei_per)
, coalesce(sum(CASE WHEN skill_tokusyukouka = "全属性ダメージ" THEN hosei_per END), 0) AS "全属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "メラ属性ダメージ" THEN hosei_per END), 0) AS "メラ属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ギラ属性ダメージ" THEN hosei_per END), 0) AS "ギラ属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ヒャド属性ダメージ" THEN hosei_per END), 0) AS "ヒャド属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "バギ属性ダメージ" THEN hosei_per END), 0) AS "バギ属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "イオ属性ダメージ" THEN hosei_per END), 0) AS "イオ属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドルマ属性ダメージ" THEN hosei_per END), 0) AS "ドルマ属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "デイン属性ダメージ" THEN hosei_per END), 0) AS "デイン属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ジバリア属性ダメージ" THEN hosei_per END), 0) AS "ジバリア属性ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "メラ属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "メラ属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ギラ属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "ギラ属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ヒャド属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "ヒャド属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "バギ属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "バギ属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "イオ属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "イオ属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドルマ属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "ドルマ属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "デイン属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "デイン属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ジバリア属性斬撃・体技ダメージ" THEN hosei_per END), 0) AS "ジバリア属性斬撃・体技ダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "メラ属性じゅもんダメージ" THEN hosei_per END), 0) AS "メラ属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ギラ属性じゅもんダメージ" THEN hosei_per END), 0) AS "ギラ属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ヒャド属性じゅもんダメージ" THEN hosei_per END), 0) AS "ヒャド属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "バギ属性じゅもんダメージ" THEN hosei_per END), 0) AS "バギ属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "イオ属性じゅもんダメージ" THEN hosei_per END), 0) AS "イオ属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドルマ属性じゅもんダメージ" THEN hosei_per END), 0) AS "ドルマ属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "デイン属性じゅもんダメージ" THEN hosei_per END), 0) AS "デイン属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ジバリア属性じゅもんダメージ" THEN hosei_per END), 0) AS "ジバリア属性じゅもんダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "スライム系へのダメージ" THEN hosei_per END), 0) AS "スライム系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "けもの系へのダメージ" THEN hosei_per END), 0) AS "けもの系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドラゴン系へのダメージ" THEN hosei_per END), 0) AS "ドラゴン系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "虫系へのダメージ" THEN hosei_per END), 0) AS "虫系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "鳥系へのダメージ" THEN hosei_per END), 0) AS "鳥系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "植物系へのダメージ" THEN hosei_per END), 0) AS "植物系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "物質系へのダメージ" THEN hosei_per END), 0) AS "物質系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "マシン系へのダメージ" THEN hosei_per END), 0) AS "マシン系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ゾンビ系へのダメージ" THEN hosei_per END), 0) AS "ゾンビ系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "悪魔系へのダメージ" THEN hosei_per END), 0) AS "悪魔系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "エレメント系へのダメージ" THEN hosei_per END), 0) AS "エレメント系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "怪人系へのダメージ" THEN hosei_per END), 0) AS "怪人系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "水系へのダメージ" THEN hosei_per END), 0) AS "水系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "？？？？系へのダメージ" THEN hosei_per END), 0) AS "？？？？系へのダメージ"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "スキルHP回復効果" THEN hosei_per END), 0) AS "スキルHP回復効果"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "とくぎHP回復効果" THEN hosei_per END), 0) AS "とくぎHP回復効果"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "じゅもんHP回復効果" THEN hosei_per END), 0) AS "じゅもんHP回復効果"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "みかわし率" THEN hosei_per END), 0) AS "みかわし率"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "全属性耐性" THEN hosei_per END), 0) AS "全属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "メラ属性耐性" THEN hosei_per END), 0) AS "メラ属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ギラ属性耐性" THEN hosei_per END), 0) AS "ギラ属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ヒャド属性耐性" THEN hosei_per END), 0) AS "ヒャド属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "バギ属性耐性" THEN hosei_per END), 0) AS "バギ属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "イオ属性耐性" THEN hosei_per END), 0) AS "イオ属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドルマ属性耐性" THEN hosei_per END), 0) AS "ドルマ属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "デイン属性耐性" THEN hosei_per END), 0) AS "デイン属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ジバリア属性耐性" THEN hosei_per END), 0) AS "ジバリア属性耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "スライム系への耐性" THEN hosei_per END), 0) AS "スライム系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "けもの系への耐性" THEN hosei_per END), 0) AS "けもの系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ドラゴン系への耐性" THEN hosei_per END), 0) AS "ドラゴン系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "虫系への耐性" THEN hosei_per END), 0) AS "虫系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "鳥系への耐性" THEN hosei_per END), 0) AS "鳥系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "植物系への耐性" THEN hosei_per END), 0) AS "植物系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "物質系への耐性" THEN hosei_per END), 0) AS "物質系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "マシン系への耐性" THEN hosei_per END), 0) AS "マシン系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ゾンビ系への耐性" THEN hosei_per END), 0) AS "ゾンビ系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "悪魔系への耐性" THEN hosei_per END), 0) AS "悪魔系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "エレメント系への耐性" THEN hosei_per END), 0) AS "エレメント系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "怪人系への耐性" THEN hosei_per END), 0) AS "怪人系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "水系への耐性" THEN hosei_per END), 0) AS "水系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "？？？？系への耐性" THEN hosei_per END), 0) AS "？？？？系への耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "すべての状態異常耐性" THEN hosei_per END), 0) AS "すべての状態異常耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "毒耐性" THEN hosei_per END), 0) AS "毒耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "麻痺耐性" THEN hosei_per END), 0) AS "麻痺耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "眠り耐性" THEN hosei_per END), 0) AS "眠り耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "混乱耐性" THEN hosei_per END), 0) AS "混乱耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "封印耐性" THEN hosei_per END), 0) AS "封印耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "幻惑耐性" THEN hosei_per END), 0) AS "幻惑耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "呪い耐性" THEN hosei_per END), 0) AS "呪い耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "魅了耐性" THEN hosei_per END), 0) AS "魅了耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "怯え耐性" THEN hosei_per END), 0) AS "怯え耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "転び耐性" THEN hosei_per END), 0) AS "転び耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "踊り耐性" THEN hosei_per END), 0) AS "踊り耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "縛り耐性" THEN hosei_per END), 0) AS "縛り耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "石化耐性" THEN hosei_per END), 0) AS "石化耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ブレス封じ耐性" THEN hosei_per END), 0) AS "ブレス封じ耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "感電耐性" THEN hosei_per END), 0) AS "感電耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "悪い状態変化耐性" THEN hosei_per END), 0) AS "悪い状態変化耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "攻撃減耐性" THEN hosei_per END), 0) AS "攻撃減耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "守備減耐性" THEN hosei_per END), 0) AS "守備減耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "すばやさ減耐性" THEN hosei_per END), 0) AS "すばやさ減耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "じゅもん攻撃減耐性" THEN hosei_per END), 0) AS "じゅもん攻撃減耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "じゅもん耐性減耐性" THEN hosei_per END), 0) AS "じゅもん耐性減耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "即死耐性" THEN hosei_per END), 0) AS "即死耐性"
, coalesce(sum(CASE WHEN skill_tokusyukouka = "ふきとばし耐性" THEN hosei_per END), 0) AS "ふきとばし耐性"FROM soubi_skill_tokusyukouka
GROUP BY skill_tokusyukouka, soubi
)

SELECT soubi
, sum("全属性ダメージ") AS "全属性ダメージ"
, sum("メラ属性ダメージ") AS "メラ属性ダメージ"
, sum("ギラ属性ダメージ") AS "ギラ属性ダメージ"
, sum("ヒャド属性ダメージ") AS "ヒャド属性ダメージ"
, sum("バギ属性ダメージ") AS "バギ属性ダメージ"
, sum("イオ属性ダメージ") AS "イオ属性ダメージ"
, sum("ドルマ属性ダメージ") AS "ドルマ属性ダメージ"
, sum("デイン属性ダメージ") AS "デイン属性ダメージ"
, sum("ジバリア属性ダメージ") AS "ジバリア属性ダメージ"
, sum("メラ属性斬撃・体技ダメージ") AS "メラ属性斬撃・体技ダメージ"
, sum("ギラ属性斬撃・体技ダメージ") AS "ギラ属性斬撃・体技ダメージ"
, sum("ヒャド属性斬撃・体技ダメージ") AS "ヒャド属性斬撃・体技ダメージ"
, sum("バギ属性斬撃・体技ダメージ") AS "バギ属性斬撃・体技ダメージ"
, sum("イオ属性斬撃・体技ダメージ") AS "イオ属性斬撃・体技ダメージ"
, sum("ドルマ属性斬撃・体技ダメージ") AS "ドルマ属性斬撃・体技ダメージ"
, sum("デイン属性斬撃・体技ダメージ") AS "デイン属性斬撃・体技ダメージ"
, sum("ジバリア属性斬撃・体技ダメージ") AS "ジバリア属性斬撃・体技ダメージ"
, sum("メラ属性じゅもんダメージ") AS "メラ属性じゅもんダメージ"
, sum("ギラ属性じゅもんダメージ") AS "ギラ属性じゅもんダメージ"
, sum("ヒャド属性じゅもんダメージ") AS "ヒャド属性じゅもんダメージ"
, sum("バギ属性じゅもんダメージ") AS "バギ属性じゅもんダメージ"
, sum("イオ属性じゅもんダメージ") AS "イオ属性じゅもんダメージ"
, sum("ドルマ属性じゅもんダメージ") AS "ドルマ属性じゅもんダメージ"
, sum("デイン属性じゅもんダメージ") AS "デイン属性じゅもんダメージ"
, sum("ジバリア属性じゅもんダメージ") AS "ジバリア属性じゅもんダメージ"
, sum("スライム系へのダメージ") AS "スライム系へのダメージ"
, sum("けもの系へのダメージ") AS "けもの系へのダメージ"
, sum("ドラゴン系へのダメージ") AS "ドラゴン系へのダメージ"
, sum("虫系へのダメージ") AS "虫系へのダメージ"
, sum("鳥系へのダメージ") AS "鳥系へのダメージ"
, sum("植物系へのダメージ") AS "植物系へのダメージ"
, sum("物質系へのダメージ") AS "物質系へのダメージ"
, sum("マシン系へのダメージ") AS "マシン系へのダメージ"
, sum("ゾンビ系へのダメージ") AS "ゾンビ系へのダメージ"
, sum("悪魔系へのダメージ") AS "悪魔系へのダメージ"
, sum("エレメント系へのダメージ") AS "エレメント系へのダメージ"
, sum("怪人系へのダメージ") AS "怪人系へのダメージ"
, sum("水系へのダメージ") AS "水系へのダメージ"
, sum("？？？？系へのダメージ") AS "？？？？系へのダメージ"
, sum("スキルHP回復効果") AS "スキルHP回復効果"
, sum("とくぎHP回復効果") AS "とくぎHP回復効果"
, sum("じゅもんHP回復効果") AS "じゅもんHP回復効果"
, sum("みかわし率") AS "みかわし率"
, sum("全属性耐性") AS "全属性耐性"
, sum("メラ属性耐性") AS "メラ属性耐性"
, sum("ギラ属性耐性") AS "ギラ属性耐性"
, sum("ヒャド属性耐性") AS "ヒャド属性耐性"
, sum("バギ属性耐性") AS "バギ属性耐性"
, sum("イオ属性耐性") AS "イオ属性耐性"
, sum("ドルマ属性耐性") AS "ドルマ属性耐性"
, sum("デイン属性耐性") AS "デイン属性耐性"
, sum("ジバリア属性耐性") AS "ジバリア属性耐性"
, sum("スライム系への耐性") AS "スライム系への耐性"
, sum("けもの系への耐性") AS "けもの系への耐性"
, sum("ドラゴン系への耐性") AS "ドラゴン系への耐性"
, sum("虫系への耐性") AS "虫系への耐性"
, sum("鳥系への耐性") AS "鳥系への耐性"
, sum("植物系への耐性") AS "植物系への耐性"
, sum("物質系への耐性") AS "物質系への耐性"
, sum("マシン系への耐性") AS "マシン系への耐性"
, sum("ゾンビ系への耐性") AS "ゾンビ系への耐性"
, sum("悪魔系への耐性") AS "悪魔系への耐性"
, sum("エレメント系への耐性") AS "エレメント系への耐性"
, sum("怪人系への耐性") AS "怪人系への耐性"
, sum("水系への耐性") AS "水系への耐性"
, sum("？？？？系への耐性") AS "？？？？系への耐性"
, sum("すべての状態異常耐性") AS "すべての状態異常耐性"
, sum("毒耐性") AS "毒耐性"
, sum("麻痺耐性") AS "麻痺耐性"
, sum("眠り耐性") AS "眠り耐性"
, sum("混乱耐性") AS "混乱耐性"
, sum("封印耐性") AS "封印耐性"
, sum("幻惑耐性") AS "幻惑耐性"
, sum("呪い耐性") AS "呪い耐性"
, sum("魅了耐性") AS "魅了耐性"
, sum("怯え耐性") AS "怯え耐性"
, sum("転び耐性") AS "転び耐性"
, sum("踊り耐性") AS "踊り耐性"
, sum("縛り耐性") AS "縛り耐性"
, sum("石化耐性") AS "石化耐性"
, sum("ブレス封じ耐性") AS "ブレス封じ耐性"
, sum("感電耐性") AS "感電耐性"
, sum("悪い状態変化耐性") AS "悪い状態変化耐性"
, sum("攻撃減耐性") AS "攻撃減耐性"
, sum("守備減耐性") AS "守備減耐性"
, sum("すばやさ減耐性") AS "すばやさ減耐性"
, sum("じゅもん攻撃減耐性") AS "じゅもん攻撃減耐性"
, sum("じゅもん耐性減耐性") AS "じゅもん耐性減耐性"
, sum("即死耐性") AS "即死耐性"
, sum("ふきとばし耐性") AS "ふきとばし耐性"
FROM table_a
GROUP BY soubi
order by soubi, skill_tokusyukouka
/* soubi_hosei(soubi,"全属性ダメージ","メラ属性ダメージ","ギラ属性ダメージ","ヒャド属性ダメージ","バギ属性ダメージ","イオ属性ダメージ","ドルマ属性ダメージ","デイン属性ダメージ","ジバリア属性ダメージ","メラ属性斬撃・体技ダメージ","ギラ属性斬撃・体技ダメージ","ヒャド属性斬撃・体技ダメージ","バギ属性斬撃・体技ダメージ","イオ属性斬撃・体技ダメージ","ドルマ属性斬撃・体技ダメージ","デイン属性斬撃・体技ダメージ","ジバリア属性斬撃・体技ダメージ","メラ属性じゅもんダメージ","ギラ属性じゅもんダメージ","ヒャド属性じゅもんダメージ","バギ属性じゅもんダメージ","イオ属性じゅもんダメージ","ドルマ属性じゅもんダメージ","デイン属性じゅもんダメージ","ジバリア属性じゅもんダメージ","スライム系へのダメージ","けもの系へのダメージ","ドラゴン系へのダメージ","虫系へのダメージ","鳥系へのダメージ","植物系へのダメージ","物質系へのダメージ","マシン系へのダメージ","ゾンビ系へのダメージ","悪魔系へのダメージ","エレメント系へのダメージ","怪人系へのダメージ","水系へのダメージ","？？？？系へのダメージ","スキルHP回復効果","とくぎHP回復効果","じゅもんHP回復効果","みかわし率","全属性耐性","メラ属性耐性","ギラ属性耐性","ヒャド属性耐性","バギ属性耐性","イオ属性耐性","ドルマ属性耐性","デイン属性耐性","ジバリア属性耐性","スライム系への耐性","けもの系への耐性","ドラゴン系への耐性","虫系への耐性","鳥系への耐性","植物系への耐性","物質系への耐性","マシン系への耐性","ゾンビ系への耐性","悪魔系への耐性","エレメント系への耐性","怪人系への耐性","水系への耐性","？？？？系への耐性","すべての状態異常耐性","毒耐性","麻痺耐性","眠り耐性","混乱耐性","封印耐性","幻惑耐性","呪い耐性","魅了耐性","怯え耐性","転び耐性","踊り耐性","縛り耐性","石化耐性","ブレス封じ耐性","感電耐性","悪い状態変化耐性","攻撃減耐性","守備減耐性","すばやさ減耐性","じゅもん攻撃減耐性","じゅもん耐性減耐性","即死耐性","ふきとばし耐性") */;
