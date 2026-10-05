-- SQL基礎レッスン課題

/* Q1  テーブル作成
  テーブル名:departments(部署)

  カラム一覧
  主キーカラム名:department_id(部署ID), データ型:INT unsigned, NULL:NO, デフォルト値:なし, 備考:AUTO_INCREMENT 
  カラム名:name(部署名), データ型:VARCHAR(20), NULL:NO, デフォルト値:なし, 備考:なし
  カラム名:created_at(作成日時), データ型:TIMESTAMP, NULL:YES, デフォルト値:CURRENT_TIMESTAMP, 備考:なし
  カラム名:updated_at(更新日時), データ型:TIMESTAMP, NULL:YES, デフォルト値:CURRENT_TIMESTAMP, 備考:ON UPDATE CURRENT_TIMESTAMP
*/

CREATE TABLE departments (
    department_id INT unsigned NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (department_id)
);

/* Q2 カラム追加
  対象テーブル:people
  追加カラム名:department_id(部署ID), データ型:INT UNSIGNED, NULL:YES, デフォルト値:なし, emailの後ろに追加する
*/

ALTER TABLE people
ADD COLUMN department_id INT UNSIGNED NULL
AFTER email;

/*Q3　レコード作成
  追加する部署一覧(departments)
  ・営業
  ・開発
  ・経理
  ・人事
  ・情報システム
*/
INSERT INTO departments (name)
VALUES
    ('営業'),
    ('開発'),
    ('経理'),
    ('人事'),
    ('情報システム');

/*Q3　レコード作成
  追加する人の条件(people)
  ・10人分のレコードを追加する 
  人数比率は営業3人、開発4人、経理1人、人事1人、情報システム1人
*/

INSERT INTO people (name, email, department_id, age, gender)
VALUES
    ('佐藤けんじ', 'sato@gizumo.jp', 1, 28, 1),
    ('高橋みさき', 'takahashi@gizumo.jp', 1, 31, 2),
    ('伊藤しょうた', 'ito@gizumo.jp', 1, 24, 1),
    ('渡辺あかり', 'watanabe@gizumo.jp', 2, 27, 2),
    ('山本ゆうすけ', 'yamamoto@gizumo.jp', 2, 35, 1),
    ('中村さやか', 'nakamura@gizumo.jp', 2, 29, 2),
    ('小林なおき', 'kobayashi@gizumo.jp', 2, 26, 1),
    ('加藤まゆみ', 'kato@gizumo.jp', 3, 33, 2),
    ('吉田たくや', 'yoshida@gizumo.jp', 4, 30, 1),
    ('山口えり', 'yamaguchi@gizumo.jp', 5, 27, 2);


/*Q3　レコード作成
  追加する日報の条件(reports)
  ・10件の日報を追加する
  ・日報は誰に紐付けてもいいが、存在しないperson_idとは紐付けない
  ・日報の文字数は最低10文字で、同じ日報を作成しない
*/

INSERT INTO reports (person_id, content)
VALUES
    (27, '本日は営業部で顧客への電話対応と資料作成を行いました。'),
    (27, '本日は顧客先でプレゼンテーションを行いました。'),
    (28, '午前中に顧客との打ち合わせを行い、午後は提案資料を整理しました。'),
    (29, '新規顧客へのアプローチを行い、問い合わせ内容について確認しました。'),
    (30, '開発チームで仕様確認を行い、担当している機能の実装を進めました。'),
    (31, '既存機能のコードを確認し、不具合の修正と動作確認を行いました。'),
    (32, 'チームメンバーと進捗を共有し、明日の作業内容について整理しました。'),
    (33, 'データベース周辺の処理を確認し、テスト環境で動作検証を行いました。'),
    (34, '経理業務として請求書の確認と今月の経費データの整理を行いました。'),
    (35, '人事関連の書類を確認し、社員情報の更新作業を進めました。');

/*Q4 既存データへのデータ追加
対象テーブル:people
追加条件:部署IDがNULLのデータに部署IDを追加
追加内容:peopleテーブル内の部署IDがNULLのデータに部署テーブル(departments)に存在する部署IDをランダムに追加する
*/

UPDATE people p
JOIN (
    SELECT person_id,
           (
               SELECT department_id
               FROM departments
               ORDER BY RAND()
               LIMIT 1
           ) AS random_department_id
    FROM people
    WHERE department_id IS NULL
) r ON p.person_id = r.person_id
SET p.department_id = r.random_department_id;

/*Q5 データ取得
  取得内容:年齢の降順で男性の名前と年齢を取得してください
*/
SELECT name, age
FROM people
WHERE gender = 1
ORDER BY age DESC;

/*Q6 SQL文の説明
対象:
SELECT
  `name`, `email`, `age`
FROM
  `people`
WHERE
  `department_id` = 1
ORDER BY
  `created_at`;
条件:テーブル・レコード・カラムという3つの単語を適切に使用する。
*/

/*
回答:
peopleテーブルから、department_idカラムの値が1であるレコードを対象に
カラム名『name・email・age』のデータをcreated_atの昇順から並べて取得する。
*/

/*Q7 データ取得
  条件:20代の女性と40代の男性の名前一覧を取得してください。
*/

SELECT name
FROM people
WHERE (gender = 1 AND age BETWEEN 40 AND 49)
   OR (gender = 2 AND age BETWEEN 20 AND 29);

/*Q8 データ取得
  条件:営業部に所属する人だけを年齢の昇順で取得してください。
*/

SELECT name, age ,department_id
FROM people
WHERE department_id = 1
ORDER BY age;

/*Q9 平均年齢取得
  条件:開発部に所属している女性の平均年齢を取得してください。 
*/

SELECT AVG(age) AS average_age
FROM people
WHERE department_id = 2
  AND gender = 2;

/*Q10 3つのテーブル結合
  名前と部署名とその人が提出した日報の内容を同時に取得してください。（日報を提出していない人は含めない） 
*/

SELECT p.name, d.name, r.content
FROM people p 
JOIN departments AS d
    ON p.department_id = d.department_id
JOIN reports AS r
    ON p.person_id = r.person_id;

/*Q11 条件指定つきテーブル結合
  条件:日報を一つも提出していない人の名前一覧を取得してください。
*/

SELECT
    p.name
FROM people AS p
LEFT JOIN reports AS r
    ON p.person_id = r.person_id
WHERE r.person_id IS NULL;
