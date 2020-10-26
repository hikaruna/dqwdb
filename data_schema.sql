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
CREATE VIEW "こころview" AS SELECT `こころ`.*, `特殊効果`.`名前`,
CASE WHEN `値` IS NULL
THEN 0
ELSE `値`
END
AS `値`
 FROM `特殊効果`
 CROSS JOIN `こころ`
 LEFT OUTER JOIN `こころの特殊効果` ON
  `こころの特殊効果`.`こころ` = `こころ`.`モンスター`
  AND
  `こころの特殊効果`.`グレード` = `こころ`.`グレード`
  AND
  `こころの特殊効果`.`特殊効果` = `特殊効果`.`名前`
ORDER BY `こころ`.rowid;
DROP VIEW IF EXISTS "MindPivotView";
CREATE VIEW "MindPivotView" AS 
SELECT `モンスター`
,max(case when `名前` = 'けもの系へのダメージ' THEN `値` END) AS `けもの系へのダメージ`
,max(case when `名前` = 'こころ最大コスト' THEN `値` END) AS `こころ最大コスト`
,max(case when `名前` = 'さいだいMP' THEN `値` END) AS `さいだいMP`
,max(case when `名前` = 'じゅもんダメージ' THEN `値` END) AS `じゅもんダメージ`
,max(case when `名前` = 'じゅもん耐性' THEN `値` END) AS `じゅもん耐性`
,max(case when `名前` = 'すばやさ減耐性' THEN `値` END) AS `すばやさ減耐性`
,max(case when `名前` = 'イオ属性じゅもんダメージ' THEN `値` END) AS `イオ属性じゅもんダメージ`
,max(case when `名前` = 'イオ属性とくぎダメージ' THEN `値` END) AS `イオ属性とくぎダメージ`
,max(case when `名前` = 'イオ属性ダメージ' THEN `値` END) AS `イオ属性ダメージ`
,max(case when `名前` = 'イオ属性耐性' THEN `値` END) AS `イオ属性耐性`
,max(case when `名前` = 'ガード率' THEN `値` END) AS `ガード率`
,max(case when `名前` = 'ギラ属性じゅもんダメージ' THEN `値` END) AS `ギラ属性じゅもんダメージ`
,max(case when `名前` = 'ギラ属性とくぎダメージ' THEN `値` END) AS `ギラ属性とくぎダメージ`
,max(case when `名前` = 'ギラ属性ダメージ' THEN `値` END) AS `ギラ属性ダメージ`
,max(case when `名前` = 'ギラ属性耐性' THEN `値` END) AS `ギラ属性耐性`
,max(case when `名前` = 'ジバリア属性とくぎダメージ' THEN `値` END) AS `ジバリア属性とくぎダメージ`
,max(case when `名前` = 'ジバリア属性ダメージ' THEN `値` END) AS `ジバリア属性ダメージ`
,max(case when `名前` = 'ジバリア属性耐性' THEN `値` END) AS `ジバリア属性耐性`
,max(case when `名前` = 'スキルHP回復効果' THEN `値` END) AS `スキルHP回復効果`
,max(case when `名前` = 'スキルの体技ダメージ' THEN `値` END) AS `スキルの体技ダメージ`
,max(case when `名前` = 'スキルの斬撃ダメージ' THEN `値` END) AS `スキルの斬撃ダメージ`
,max(case when `名前` = 'スキルの斬撃体技ダメージ' THEN `値` END) AS `スキルの斬撃体技ダメージ`
,max(case when `名前` = 'スライム系へのダメージ' THEN `値` END) AS `スライム系へのダメージ`
,max(case when `名前` = 'ゾンビ系へのダメージ' THEN `値` END) AS `ゾンビ系へのダメージ`
,max(case when `名前` = 'ターン開始時HPを回復する' THEN `値` END) AS `ターン開始時HPを回復する`
,max(case when `名前` = 'ターン開始時MPを回復する' THEN `値` END) AS `ターン開始時MPを回復する`
,max(case when `名前` = 'デイン属性じゅもんダメージ' THEN `値` END) AS `デイン属性じゅもんダメージ`
,max(case when `名前` = 'デイン属性とくぎダメージ' THEN `値` END) AS `デイン属性とくぎダメージ`
,max(case when `名前` = 'デイン属性ダメージ' THEN `値` END) AS `デイン属性ダメージ`
,max(case when `名前` = 'デイン属性耐性' THEN `値` END) AS `デイン属性耐性`
,max(case when `名前` = 'ドラゴンガイアへの耐性' THEN `値` END) AS `ドラゴンガイアへの耐性`
,max(case when `名前` = 'ドラゴンゾンビへの耐性' THEN `値` END) AS `ドラゴンゾンビへの耐性`
,max(case when `名前` = 'ドラゴン系へのダメージ' THEN `値` END) AS `ドラゴン系へのダメージ`
,max(case when `名前` = 'ドルマ属性じゅもんダメージ' THEN `値` END) AS `ドルマ属性じゅもんダメージ`
,max(case when `名前` = 'ドルマ属性とくぎダメージ' THEN `値` END) AS `ドルマ属性とくぎダメージ`
,max(case when `名前` = 'ドルマ属性耐性' THEN `値` END) AS `ドルマ属性耐性`
,max(case when `名前` = 'バギ属性じゅもんダメージ' THEN `値` END) AS `バギ属性じゅもんダメージ`
,max(case when `名前` = 'バギ属性とくぎダメージ' THEN `値` END) AS `バギ属性とくぎダメージ`
,max(case when `名前` = 'バギ属性ダメージ' THEN `値` END) AS `バギ属性ダメージ`
,max(case when `名前` = 'バギ属性耐性' THEN `値` END) AS `バギ属性耐性`
,max(case when `名前` = 'ヒャド属性じゅもんダメージ' THEN `値` END) AS `ヒャド属性じゅもんダメージ`
,max(case when `名前` = 'ヒャド属性とくぎダメージ' THEN `値` END) AS `ヒャド属性とくぎダメージ`
,max(case when `名前` = 'ヒャド属性ダメージ' THEN `値` END) AS `ヒャド属性ダメージ`
,max(case when `名前` = 'ヒャド属性耐性' THEN `値` END) AS `ヒャド属性耐性`
,max(case when `名前` = 'ブレス耐性' THEN `値` END) AS `ブレス耐性`
,max(case when `名前` = 'ヘルジュラシックへの耐性' THEN `値` END) AS `ヘルジュラシックへの耐性`
,max(case when `名前` = 'マシン系へのダメージ' THEN `値` END) AS `マシン系へのダメージ`
,max(case when `名前` = 'メラ属性じゅもんダメージ' THEN `値` END) AS `メラ属性じゅもんダメージ`
,max(case when `名前` = 'メラ属性とくぎダメージ' THEN `値` END) AS `メラ属性とくぎダメージ`
,max(case when `名前` = 'メラ属性ダメージ' THEN `値` END) AS `メラ属性ダメージ`
,max(case when `名前` = 'メラ属性耐性' THEN `値` END) AS `メラ属性耐性`
,max(case when `名前` = '不利な状態変化耐性' THEN `値` END) AS `不利な状態変化耐性`
,max(case when `名前` = '会心率' THEN `値` END) AS `会心率`
,max(case when `名前` = '全属性耐性' THEN `値` END) AS `全属性耐性`
,max(case when `名前` = '即死耐性' THEN `値` END) AS `即死耐性`
,max(case when `名前` = '吸収耐性' THEN `値` END) AS `吸収耐性`
,max(case when `名前` = '呪い耐性' THEN `値` END) AS `呪い耐性`
,max(case when `名前` = '封印耐性' THEN `値` END) AS `封印耐性`
,max(case when `名前` = '幻惑耐性' THEN `値` END) AS `幻惑耐性`
,max(case when `名前` = '怪人系へのダメージ' THEN `値` END) AS `怪人系へのダメージ`
,max(case when `名前` = '怯え耐性' THEN `値` END) AS `怯え耐性`
,max(case when `名前` = '悪魔系へのダメージ' THEN `値` END) AS `悪魔系へのダメージ`
,max(case when `名前` = '戦闘時のどうぐHP回復効果' THEN `値` END) AS `戦闘時のどうぐHP回復効果`
,max(case when `名前` = '戦闘時のどうぐMP回復効果' THEN `値` END) AS `戦闘時のどうぐMP回復効果`
,max(case when `名前` = '戦闘終了時にHPを回復する' THEN `値` END) AS `戦闘終了時にHPを回復する`
,max(case when `名前` = '戦闘終了時にMPを回復する' THEN `値` END) AS `戦闘終了時にMPを回復する`
,max(case when `名前` = '攻撃減耐性' THEN `値` END) AS `攻撃減耐性`
,max(case when `名前` = '毒耐性' THEN `値` END) AS `毒耐性`
,max(case when `名前` = '混乱耐性' THEN `値` END) AS `混乱耐性`
,max(case when `名前` = '眠り耐性' THEN `値` END) AS `眠り耐性`
,max(case when `名前` = '縛り耐性' THEN `値` END) AS `縛り耐性`
,max(case when `名前` = '踊り耐性' THEN `値` END) AS `踊り耐性`
,max(case when `名前` = '転び耐性' THEN `値` END) AS `転び耐性`
,max(case when `名前` = '防御減耐性' THEN `値` END) AS `防御減耐性`
,max(case when `名前` = '魅了耐性' THEN `値` END) AS `魅了耐性`
,max(case when `名前` = '魔力の暴走率' THEN `値` END) AS `魔力の暴走率`
,max(case when `名前` = '麻痺耐性' THEN `値` END) AS `麻痺耐性`
FROM `こころview`
GROUP BY `モンスター`, `グレード`
;
COMMIT;
