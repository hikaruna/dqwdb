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
CREATE TABLE IF NOT EXISTS "zyoutaihenka" (
	"zyoutaihenka"	TEXT NOT NULL,
	"order"	INT NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaihenka")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaihenka_group_zyoutaihenka" (
	"zyoutaihenka_group"	TEXT NOT NULL,
	"zyoutaihenka"	TEXT NOT NULL,
	PRIMARY KEY("zyoutaihenka_group","zyoutaihenka"),
	FOREIGN KEY("zyoutaihenka") REFERENCES "zyoutaihenka"("zyoutaihenka") ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY("zyoutaihenka_group") REFERENCES "zyoutaihenka_group"("zyoutaihenka_group") ON UPDATE RESTRICT ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaiizyou_group_zyoutaiizyou" (
	"zyoutaiizyou_group"	TEXT NOT NULL,
	"zyoutaiizyou"	TEXT NOT NULL,
	PRIMARY KEY("zyoutaiizyou_group","zyoutaiizyou"),
	FOREIGN KEY("zyoutaiizyou") REFERENCES "zyoutaiizyou"("zyoutaiizyou") ON UPDATE RESTRICT ON DELETE RESTRICT,
	FOREIGN KEY("zyoutaiizyou_group") REFERENCES "zyoutaiizyou_group"("zyoutaiizyou_group") ON UPDATE RESTRICT ON DELETE RESTRICT
) STRICT;
CREATE TABLE IF NOT EXISTS "soubi" (
	"soubi"	TEXT NOT NULL,
	"skill_tokusyukouka_text"	TEXT NOT NULL,
	PRIMARY KEY("soubi")
) STRICT;
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE sqlite_stat4(tbl,idx,neq,nlt,ndlt,sample);
CREATE TABLE IF NOT EXISTS "sonota" (
	"sonota"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("sonota")
) STRICT;
CREATE TABLE IF NOT EXISTS "kouka" (
	"kouka"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	"table_order"	INTEGER NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("kouka")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaiizyou_group" (
	"zyoutaiizyou_group"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaiizyou_group")
) STRICT;
CREATE TABLE IF NOT EXISTS "zyoutaihenka_group" (
	"zyoutaihenka_group"	TEXT NOT NULL,
	"order"	INT NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("zyoutaihenka_group")
) STRICT;
CREATE TABLE IF NOT EXISTS "taisyou" (
	"taisyou"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	"table_order"	INTEGER NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("taisyou")
) STRICT;
CREATE TABLE IF NOT EXISTS "zokusei_group" (
	"zokusei_group"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	PRIMARY KEY("zokusei_group")
) STRICT;
CREATE TABLE IF NOT EXISTS "kisoparameter" (
	"kisoparameter"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("kisoparameter")
) STRICT;
CREATE TABLE IF NOT EXISTS "kakuritu" (
	"kakuritu"	TEXT NOT NULL,
	"order"	INTEGER NOT NULL UNIQUE,
	"tokusyukouka_text"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("kakuritu")
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
	,'(^|\n)スキルのHP回復効果','$1スキルHP回復効果')
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
CREATE VIEW taisyou_hosei_tokusyukouka_variation AS
SELECT kouka
, kouka.table_order AS kouka_order
, taisyou
, taisyou.table_order AS taisyou_order
, taisyou.tokusyukouka_text
, taisyou.tokusyukouka_text||kouka.tokusyukouka_text AS tokusyukouka
FROM taisyou
CROSS JOIN kouka
WHERE NOT(
  kouka = "ダメージアップ" AND taisyou IN("とくぎ","どうぐ")
  OR
  kouka = "HP回復" AND taisyou NOT IN("スキル","じゅもん","とくぎ")
  OR
  kouka = "成功率"
  OR
  kouka = "耐性" AND taisyou NOT IN("斬撃・体技","ブレス","じゅもん")
)
order by kouka_order, taisyou_order
/* taisyou_hosei_tokusyukouka_variation(kouka,kouka_order,taisyou,taisyou_order,tokusyukouka_text,tokusyukouka) */;
CREATE VIEW zyoutai_hosei_tokusyukouka_variation AS

SELECT kouka
, kouka.table_order AS kouka_order
, zyoutaiizyou_group
, zyoutaiizyou_group.`order` AS zyoutaiizyou_group_order
, zyoutaihenka_group
, zyoutaihenka_group.`order` AS zyoutaihenka_group_order
, sonota
, sonota.`order` AS sonota_order
, zyoutaiizyou_group.tokusyukouka_text
||zyoutaihenka_group.tokusyukouka_text
||sonota
||kouka.tokusyukouka_text
AS tokusyukouka


FROM (

SELECT zyoutaiizyou_group
, zyoutaiizyou_group.`order` AS `order`
, tokusyukouka_text
FROM zyoutaiizyou_group
UNION ALL
SELECT ""
, 99
, ""
) AS zyoutaiizyou_group


CROSS JOIN (

SELECT zyoutaihenka_group
, zyoutaihenka_group.`order` AS `order`
, tokusyukouka_text
FROM zyoutaihenka_group
UNION ALL
SELECT ""
, 99
, ""
) AS zyoutaihenka_group

CROSS JOIN (

SELECT sonota
, sonota.`order` AS `order`
FROM sonota
UNION ALL
SELECT ""
, 99
) AS sonota


CROSS JOIN kouka
WHERE
  (
    (zyoutaiizyou_group != "" AND zyoutaihenka_group = "" AND sonota = "")
    OR
    (zyoutaiizyou_group = "" AND zyoutaihenka_group != "" AND sonota = "")
    OR
    (zyoutaiizyou_group = "" AND zyoutaihenka_group = "" AND sonota != "")
   )
 AND
 NOT(zyoutaiizyou_group = "" AND zyoutaihenka_group = "" AND sonota = "")
 AND kouka IN("成功率","耐性")
 AND NOT(zyoutaihenka_group = "悪状態変化" AND kouka = "成功率")
 AND NOT(zyoutaihenka_group = "一部の状態変化" AND kouka = "耐性")
order by kouka.table_order, zyoutaiizyou_group.`order`, zyoutaihenka_group.`order`
/* zyoutai_hosei_tokusyukouka_variation(kouka,kouka_order,zyoutaiizyou_group,zyoutaiizyou_group_order,zyoutaihenka_group,zyoutaihenka_group_order,sonota,sonota_order,tokusyukouka) */;
CREATE VIEW value_hosei_tokusyukouka_variation AS

SELECT kisoparameter
, `order` AS kisoparameter_order
, "" AS kakuritu
, "" AS kakuritu_order
, tokusyukouka_text AS tokusyukouka
FROM kisoparameter

UNION ALL
SELECT "" AS kisoparameter
, "" AS kisoparameter_order
, kakuritu
, `order` AS kakuritu_order
, tokusyukouka_text AS tokusyukouka
FROM kakuritu
/* value_hosei_tokusyukouka_variation(kisoparameter,kisoparameter_order,kakuritu,kakuritu_order,tokusyukouka) */;
CREATE VIEW per_hosei_tokusyukouka_variation AS

WITH intermate AS (

SELECT kouka
, kouka_order
, taisyou
, taisyou_order+1 AS taisyou_order
, "" AS zokusei
, 1 AS zokusei_order
, "" AS keitou
, "" AS keitou_order
, "" AS zyoutaiizyou
, "" AS zyoutaiizyou_order
, "" AS zyoutaihenka
, "" AS zyoutaihenka_order
, "" AS sonota
, "" AS sonota_order
, tokusyukouka

FROM taisyou_hosei_tokusyukouka_variation


UNION ALL
SELECT kouka
, kouka_order
, taisyou
, taisyou_order
, zokusei
, zokusei_order+1 AS zokusei_order
, "" AS keitou
, "" AS keitou_order
, "" AS zyoutaiizyou
, "" AS zyoutaiizyou_order
, "" AS zyoutaihenka
, "" AS zyoutaihenka_order
, "" AS sonota
, "" AS sonota_order
, tokusyukouka

FROM zokusei_hosei_tokusyukouka_variation


UNION ALL
SELECT kouka
, kouka_order
, "" AS taisyou
, "" AS taisyou_order
, "" AS zokusei
, 1 AS zokusei_order
, keitou
, keitou_order
, "" AS zyoutaiizyou
, "" AS zyoutaiizyou_order
, "" AS zyoutaihenka
, "" AS zyoutaihenka_order
, "" AS sonota
, "" AS sonota_order
, tokusyukouka

FROM keitou_hosei_tokusyukouka_variation


UNION ALL
SELECT kouka
, kouka_order
, "" AS taisyou
, "" AS taisyou_order
, "" AS zokusei
, 1 AS zokusei_order
, "" AS keitou
, "" AS keitou_order
, zyoutaiizyou_group AS zyoutaiizyou
, zyoutaiizyou_group_order AS zyoutaiizyou_order
, zyoutaihenka_group AS zyoutaihenka
, zyoutaihenka_group_order AS zyoutaihenka_order
, sonota
, sonota_order
, tokusyukouka

FROM zyoutai_hosei_tokusyukouka_variation
)

SELECT * FROM intermate
order by
kouka_order
,
(
CASE
WHEN taisyou != "" AND zokusei = "" THEN 1
ELSE 99
END
)
,
taisyou_order
,
zokusei_order
,
keitou_order
,
zyoutaiizyou_order
,
zyoutaihenka_order
,
sonota_order
/* per_hosei_tokusyukouka_variation(kouka,kouka_order,taisyou,taisyou_order,zokusei,zokusei_order,keitou,keitou_order,zyoutaiizyou,zyoutaiizyou_order,zyoutaihenka,zyoutaihenka_order,sonota,sonota_order,tokusyukouka) */;
CREATE VIEW keitou_hosei_tokusyukouka_variation AS

SELECT kouka
, kouka.table_order AS kouka_order
, keitou
, keitou.`order` AS keitou_order
, keitou||"への"
||kouka.tokusyukouka_text
AS tokusyukouka


FROM keitou

CROSS JOIN kouka
WHERE
 kouka IN("ダメージアップ","耐性")
order by kouka.table_order, keitou_order
/* keitou_hosei_tokusyukouka_variation(kouka,kouka_order,keitou,keitou_order,tokusyukouka) */;
CREATE VIEW create_soubi_hosei_view AS

SELECT "SELECT soubi" AS sql

UNION ALL
SELECT
", coalesce(sum(CASE WHEN skill_tokusyukouka = '"||tokusyukouka||"' THEN hosei_per END), 0) AS '"||tokusyukouka||"'"
FROM hosei_tokusyukouka_variation

UNION ALL
SELECT "FROM soubi_skill_tokusyukouka"

UNION ALL
SELECT "GROUP BY soubi"
/* create_soubi_hosei_view(sql) */;
CREATE VIEW soubi_hosei AS

SELECT soubi
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'さいだいHP' THEN hosei_per END), 0) AS 'さいだいHP'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'さいだいMP' THEN hosei_per END), 0) AS 'さいだいMP'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '攻撃力' THEN hosei_per END), 0) AS '攻撃力'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '守備力' THEN hosei_per END), 0) AS '守備力'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'こうげき魔力' THEN hosei_per END), 0) AS 'こうげき魔力'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'かいふく魔力' THEN hosei_per END), 0) AS 'かいふく魔力'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ちから' THEN hosei_per END), 0) AS 'ちから'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'みのまもり' THEN hosei_per END), 0) AS 'みのまもり'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'すばやさ' THEN hosei_per END), 0) AS 'すばやさ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'きようさ' THEN hosei_per END), 0) AS 'きようさ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '会心率' THEN hosei_per END), 0) AS '会心率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'みかわし率' THEN hosei_per END), 0) AS 'みかわし率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ガード率' THEN hosei_per END), 0) AS 'ガード率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '魔力の暴走率' THEN hosei_per END), 0) AS '魔力の暴走率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スキルダメージ' THEN hosei_per END), 0) AS 'スキルダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '斬撃・体技ダメージ' THEN hosei_per END), 0) AS '斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スキルの斬撃ダメージ' THEN hosei_per END), 0) AS 'スキルの斬撃ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スキルの体技ダメージ' THEN hosei_per END), 0) AS 'スキルの体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ブレスダメージ' THEN hosei_per END), 0) AS 'ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'じゅもんダメージ' THEN hosei_per END), 0) AS 'じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '斬撃・体技・ブレスダメージ' THEN hosei_per END), 0) AS '斬撃・体技・ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '全属性ダメージ' THEN hosei_per END), 0) AS '全属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'メラ属性ダメージ' THEN hosei_per END), 0) AS 'メラ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ギラ属性ダメージ' THEN hosei_per END), 0) AS 'ギラ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ヒャド属性ダメージ' THEN hosei_per END), 0) AS 'ヒャド属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'バギ属性ダメージ' THEN hosei_per END), 0) AS 'バギ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'デイン属性ダメージ' THEN hosei_per END), 0) AS 'デイン属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ジバリア属性ダメージ' THEN hosei_per END), 0) AS 'ジバリア属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'イオ属性ダメージ' THEN hosei_per END), 0) AS 'イオ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドルマ属性ダメージ' THEN hosei_per END), 0) AS 'ドルマ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ザバ属性ダメージ' THEN hosei_per END), 0) AS 'ザバ属性ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '全属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS '全属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'メラ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'メラ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ギラ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'ギラ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ヒャド属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'ヒャド属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'バギ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'バギ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'デイン属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'デイン属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ジバリア属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'ジバリア属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'イオ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'イオ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドルマ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'ドルマ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ザバ属性斬撃・体技ダメージ' THEN hosei_per END), 0) AS 'ザバ属性斬撃・体技ダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '全属性ブレスダメージ' THEN hosei_per END), 0) AS '全属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'メラ属性ブレスダメージ' THEN hosei_per END), 0) AS 'メラ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ギラ属性ブレスダメージ' THEN hosei_per END), 0) AS 'ギラ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ヒャド属性ブレスダメージ' THEN hosei_per END), 0) AS 'ヒャド属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'バギ属性ブレスダメージ' THEN hosei_per END), 0) AS 'バギ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'デイン属性ブレスダメージ' THEN hosei_per END), 0) AS 'デイン属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ジバリア属性ブレスダメージ' THEN hosei_per END), 0) AS 'ジバリア属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'イオ属性ブレスダメージ' THEN hosei_per END), 0) AS 'イオ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドルマ属性ブレスダメージ' THEN hosei_per END), 0) AS 'ドルマ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ザバ属性ブレスダメージ' THEN hosei_per END), 0) AS 'ザバ属性ブレスダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '全属性じゅもんダメージ' THEN hosei_per END), 0) AS '全属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'メラ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'メラ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ギラ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'ギラ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ヒャド属性じゅもんダメージ' THEN hosei_per END), 0) AS 'ヒャド属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'バギ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'バギ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'デイン属性じゅもんダメージ' THEN hosei_per END), 0) AS 'デイン属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ジバリア属性じゅもんダメージ' THEN hosei_per END), 0) AS 'ジバリア属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'イオ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'イオ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドルマ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'ドルマ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ザバ属性じゅもんダメージ' THEN hosei_per END), 0) AS 'ザバ属性じゅもんダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スライム系へのダメージ' THEN hosei_per END), 0) AS 'スライム系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'けもの系へのダメージ' THEN hosei_per END), 0) AS 'けもの系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドラゴン系へのダメージ' THEN hosei_per END), 0) AS 'ドラゴン系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '虫系へのダメージ' THEN hosei_per END), 0) AS '虫系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '鳥系へのダメージ' THEN hosei_per END), 0) AS '鳥系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '植物系へのダメージ' THEN hosei_per END), 0) AS '植物系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '物質系へのダメージ' THEN hosei_per END), 0) AS '物質系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'マシン系へのダメージ' THEN hosei_per END), 0) AS 'マシン系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ゾンビ系へのダメージ' THEN hosei_per END), 0) AS 'ゾンビ系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '悪魔系へのダメージ' THEN hosei_per END), 0) AS '悪魔系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'エレメント系へのダメージ' THEN hosei_per END), 0) AS 'エレメント系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '怪人系へのダメージ' THEN hosei_per END), 0) AS '怪人系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '水系へのダメージ' THEN hosei_per END), 0) AS '水系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '????系へのダメージ' THEN hosei_per END), 0) AS '????系へのダメージ'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スキルHP回復効果' THEN hosei_per END), 0) AS 'スキルHP回復効果'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'じゅもんHP回復効果' THEN hosei_per END), 0) AS 'じゅもんHP回復効果'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'とくぎHP回復効果' THEN hosei_per END), 0) AS 'とくぎHP回復効果'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'すべての状態異常成功率' THEN hosei_per END), 0) AS 'すべての状態異常成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '毒成功率' THEN hosei_per END), 0) AS '毒成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '麻痺成功率' THEN hosei_per END), 0) AS '麻痺成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '眠り成功率' THEN hosei_per END), 0) AS '眠り成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '混乱成功率' THEN hosei_per END), 0) AS '混乱成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '封印成功率' THEN hosei_per END), 0) AS '封印成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '幻惑成功率' THEN hosei_per END), 0) AS '幻惑成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '呪い成功率' THEN hosei_per END), 0) AS '呪い成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '魅了成功率' THEN hosei_per END), 0) AS '魅了成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '休み成功率' THEN hosei_per END), 0) AS '休み成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '怯え成功率' THEN hosei_per END), 0) AS '怯え成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '転び成功率' THEN hosei_per END), 0) AS '転び成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '踊り成功率' THEN hosei_per END), 0) AS '踊り成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '縛り成功率' THEN hosei_per END), 0) AS '縛り成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '石化成功率' THEN hosei_per END), 0) AS '石化成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ブレス封じ成功率' THEN hosei_per END), 0) AS 'ブレス封じ成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '一部の状態変化成功率' THEN hosei_per END), 0) AS '一部の状態変化成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '攻撃減成功率' THEN hosei_per END), 0) AS '攻撃減成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '守備減成功率' THEN hosei_per END), 0) AS '守備減成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'すばやさ減成功率' THEN hosei_per END), 0) AS 'すばやさ減成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '威圧成功率' THEN hosei_per END), 0) AS '威圧成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '衰弱成功率' THEN hosei_per END), 0) AS '衰弱成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '即死成功率' THEN hosei_per END), 0) AS '即死成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '吸収成功率' THEN hosei_per END), 0) AS '吸収成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ふきとばし成功率' THEN hosei_per END), 0) AS 'ふきとばし成功率'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '斬撃・体技耐性' THEN hosei_per END), 0) AS '斬撃・体技耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ブレス耐性' THEN hosei_per END), 0) AS 'ブレス耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'じゅもん耐性' THEN hosei_per END), 0) AS 'じゅもん耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '全属性耐性' THEN hosei_per END), 0) AS '全属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'メラ属性耐性' THEN hosei_per END), 0) AS 'メラ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ギラ属性耐性' THEN hosei_per END), 0) AS 'ギラ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ヒャド属性耐性' THEN hosei_per END), 0) AS 'ヒャド属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'バギ属性耐性' THEN hosei_per END), 0) AS 'バギ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'デイン属性耐性' THEN hosei_per END), 0) AS 'デイン属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ジバリア属性耐性' THEN hosei_per END), 0) AS 'ジバリア属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'イオ属性耐性' THEN hosei_per END), 0) AS 'イオ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドルマ属性耐性' THEN hosei_per END), 0) AS 'ドルマ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ザバ属性耐性' THEN hosei_per END), 0) AS 'ザバ属性耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'スライム系への耐性' THEN hosei_per END), 0) AS 'スライム系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'けもの系への耐性' THEN hosei_per END), 0) AS 'けもの系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ドラゴン系への耐性' THEN hosei_per END), 0) AS 'ドラゴン系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '虫系への耐性' THEN hosei_per END), 0) AS '虫系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '鳥系への耐性' THEN hosei_per END), 0) AS '鳥系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '植物系への耐性' THEN hosei_per END), 0) AS '植物系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '物質系への耐性' THEN hosei_per END), 0) AS '物質系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'マシン系への耐性' THEN hosei_per END), 0) AS 'マシン系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ゾンビ系への耐性' THEN hosei_per END), 0) AS 'ゾンビ系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '悪魔系への耐性' THEN hosei_per END), 0) AS '悪魔系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'エレメント系への耐性' THEN hosei_per END), 0) AS 'エレメント系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '怪人系への耐性' THEN hosei_per END), 0) AS '怪人系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '水系への耐性' THEN hosei_per END), 0) AS '水系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '????系への耐性' THEN hosei_per END), 0) AS '????系への耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'すべての状態異常耐性' THEN hosei_per END), 0) AS 'すべての状態異常耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '毒耐性' THEN hosei_per END), 0) AS '毒耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '麻痺耐性' THEN hosei_per END), 0) AS '麻痺耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '眠り耐性' THEN hosei_per END), 0) AS '眠り耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '混乱耐性' THEN hosei_per END), 0) AS '混乱耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '封印耐性' THEN hosei_per END), 0) AS '封印耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '幻惑耐性' THEN hosei_per END), 0) AS '幻惑耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '呪い耐性' THEN hosei_per END), 0) AS '呪い耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '魅了耐性' THEN hosei_per END), 0) AS '魅了耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '休み耐性' THEN hosei_per END), 0) AS '休み耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '怯え耐性' THEN hosei_per END), 0) AS '怯え耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '転び耐性' THEN hosei_per END), 0) AS '転び耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '踊り耐性' THEN hosei_per END), 0) AS '踊り耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '縛り耐性' THEN hosei_per END), 0) AS '縛り耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '石化耐性' THEN hosei_per END), 0) AS '石化耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ブレス封じ耐性' THEN hosei_per END), 0) AS 'ブレス封じ耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '悪い状態変化耐性' THEN hosei_per END), 0) AS '悪い状態変化耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '攻撃減耐性' THEN hosei_per END), 0) AS '攻撃減耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '守備減耐性' THEN hosei_per END), 0) AS '守備減耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'すばやさ減耐性' THEN hosei_per END), 0) AS 'すばやさ減耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '威圧耐性' THEN hosei_per END), 0) AS '威圧耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '衰弱耐性' THEN hosei_per END), 0) AS '衰弱耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '即死耐性' THEN hosei_per END), 0) AS '即死耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = '吸収耐性' THEN hosei_per END), 0) AS '吸収耐性'
, coalesce(sum(CASE WHEN skill_tokusyukouka = 'ふきとばし耐性' THEN hosei_per END), 0) AS 'ふきとばし耐性'
FROM soubi_skill_tokusyukouka
GROUP BY soubi
/* soubi_hosei(soubi,"さいだいHP","さいだいMP","攻撃力","守備力","こうげき魔力","かいふく魔力","ちから","みのまもり","すばやさ","きようさ","会心率","みかわし率","ガード率","魔力の暴走率","スキルダメージ","斬撃・体技ダメージ","スキルの斬撃ダメージ","スキルの体技ダメージ","ブレスダメージ","じゅもんダメージ","斬撃・体技・ブレスダメージ","全属性ダメージ","メラ属性ダメージ","ギラ属性ダメージ","ヒャド属性ダメージ","バギ属性ダメージ","デイン属性ダメージ","ジバリア属性ダメージ","イオ属性ダメージ","ドルマ属性ダメージ","ザバ属性ダメージ","全属性斬撃・体技ダメージ","メラ属性斬撃・体技ダメージ","ギラ属性斬撃・体技ダメージ","ヒャド属性斬撃・体技ダメージ","バギ属性斬撃・体技ダメージ","デイン属性斬撃・体技ダメージ","ジバリア属性斬撃・体技ダメージ","イオ属性斬撃・体技ダメージ","ドルマ属性斬撃・体技ダメージ","ザバ属性斬撃・体技ダメージ","全属性ブレスダメージ","メラ属性ブレスダメージ","ギラ属性ブレスダメージ","ヒャド属性ブレスダメージ","バギ属性ブレスダメージ","デイン属性ブレスダメージ","ジバリア属性ブレスダメージ","イオ属性ブレスダメージ","ドルマ属性ブレスダメージ","ザバ属性ブレスダメージ","全属性じゅもんダメージ","メラ属性じゅもんダメージ","ギラ属性じゅもんダメージ","ヒャド属性じゅもんダメージ","バギ属性じゅもんダメージ","デイン属性じゅもんダメージ","ジバリア属性じゅもんダメージ","イオ属性じゅもんダメージ","ドルマ属性じゅもんダメージ","ザバ属性じゅもんダメージ","スライム系へのダメージ","けもの系へのダメージ","ドラゴン系へのダメージ","虫系へのダメージ","鳥系へのダメージ","植物系へのダメージ","物質系へのダメージ","マシン系へのダメージ","ゾンビ系へのダメージ","悪魔系へのダメージ","エレメント系へのダメージ","怪人系へのダメージ","水系へのダメージ","????系へのダメージ","スキルHP回復効果","じゅもんHP回復効果","とくぎHP回復効果","すべての状態異常成功率","毒成功率","麻痺成功率","眠り成功率","混乱成功率","封印成功率","幻惑成功率","呪い成功率","魅了成功率","休み成功率","怯え成功率","転び成功率","踊り成功率","縛り成功率","石化成功率","ブレス封じ成功率","一部の状態変化成功率","攻撃減成功率","守備減成功率","すばやさ減成功率","威圧成功率","衰弱成功率","即死成功率","吸収成功率","ふきとばし成功率","斬撃・体技耐性","ブレス耐性","じゅもん耐性","全属性耐性","メラ属性耐性","ギラ属性耐性","ヒャド属性耐性","バギ属性耐性","デイン属性耐性","ジバリア属性耐性","イオ属性耐性","ドルマ属性耐性","ザバ属性耐性","スライム系への耐性","けもの系への耐性","ドラゴン系への耐性","虫系への耐性","鳥系への耐性","植物系への耐性","物質系への耐性","マシン系への耐性","ゾンビ系への耐性","悪魔系への耐性","エレメント系への耐性","怪人系への耐性","水系への耐性","????系への耐性","すべての状態異常耐性","毒耐性","麻痺耐性","眠り耐性","混乱耐性","封印耐性","幻惑耐性","呪い耐性","魅了耐性","休み耐性","怯え耐性","転び耐性","踊り耐性","縛り耐性","石化耐性","ブレス封じ耐性","悪い状態変化耐性","攻撃減耐性","守備減耐性","すばやさ減耐性","威圧耐性","衰弱耐性","即死耐性","吸収耐性","ふきとばし耐性") */;
CREATE VIEW zokusei_hosei_tokusyukouka_variation AS


SELECT kouka
, kouka.table_order AS kouka_order
, taisyou
, taisyou.table_order AS taisyou_order
, zokusei_group AS zokusei
, zokusei_group.`order` AS zokusei_order
, zokusei_group||"属性"||taisyou.tokusyukouka_text||kouka.tokusyukouka_text AS tokusyukouka
FROM zokusei_group
CROSS JOIN kouka

CROSS JOIN (
SELECT taisyou
, taisyou.tokusyukouka_text
, table_order+1 AS table_order
FROM taisyou
UNION ALL
SELECT ""
, ""
, 1 AS table_order
) AS taisyou

WHERE taisyou IN("","斬撃・体技","じゅもん","ブレス") AND kouka IN("ダメージアップ","耐性")
AND NOT(kouka = "耐性" AND taisyou != "")
order by kouka_order, taisyou_order, zokusei_order
/* zokusei_hosei_tokusyukouka_variation(kouka,kouka_order,taisyou,taisyou_order,zokusei,zokusei_order,tokusyukouka) */;
CREATE VIEW hosei_tokusyukouka_variation AS

SELECT tokusyukouka
FROM value_hosei_tokusyukouka_variation


UNION ALL
SELECT
/*
"" AS kisoparameter
, "" AS kisoparameter_order
, "" AS kakuritu
, "" AS kakuritu_order
,
*/
tokusyukouka

FROM per_hosei_tokusyukouka_variation
/* hosei_tokusyukouka_variation(tokusyukouka) */;
CREATE VIEW soubi_skill_tokusyukouka_intermate_no_regexp AS
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
	  skill_tokusyukouka_text
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
/* soubi_skill_tokusyukouka_intermate_no_regexp(soubi,skill_tokusyukouka_intermate) */;
