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
CREATE TABLE sqlite_stat1(tbl,idx,stat);
CREATE TABLE sqlite_stat4(tbl,idx,neq,nlt,ndlt,sample);
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
