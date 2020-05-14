# README
![トップページ](https://user-images.githubusercontent.com/62546632/81910490-01f51d80-9607-11ea-9a1a-a94e09952d99.png)
# このアプリについて
・メルカリクローンのフリーマーケットアプリ
<br>
・TECH CAMP 73期短期メンバー５名にて作成
<br>
・制作期間:2020年　4月21日〜5月13日
<br>
・各担当箇所は以下に記載

# 制作メンバー
<a href="https://github.com/ryuso0720"><h2>ryuso0720</h2></a>
<h3>実装内容</h3>
ER図作成
<br>
README編集
<br>
テーブル作成
<br>
アソシエーション記述
<br>
商品詳細ページ_マークアップ
<br>
商品一覧表示_マークアップ&サーバーサイド
<br>
商品カテゴリー機能_マークアップ&サーバーサイド

<a href="https://github.com/4145bjc"><h2>4145bjc</h2></a>
<h3>実装内容</h3>
デプロイ担当AWS EC2〜S3導入
<br>
Nginx,Unicorn,Capistrano導入
<br>
Basic認証
<br>
商品出品ページ_マークアップ
<br>
出品画像の複数投稿_サーバーサイド
<br>
出品画像のプレビュー機能

<a href="https://github.com/pikarunrun"><h2>pikarunrun</h2></a>
<h3>実装内容</h3>
トップページ_マークアップ
<br>
ユーザー新規登録_サーバーサイド
<br>
商品詳細表示_サーバーサイド
<br>
商品削除機能
<br>
パンくず
<br>
商品検索機能
<br>
バリデーション記述
<br>
エラーハンドリング

<a href="https://github.com/toraprogram"><h2>toraprogram</h2></a>
<h3>実装内容</h3>
ユーザー新規登録/ログインページ_マークアップ&サーバーサイド
<br>
ユーザー新規登録_単体テスト
<br>
商品情報編集
<br>
商品編集画像プレビュー表示
<br>
二重投稿防止機能


<a href="https://github.com/sayuroy"><h2>sayuroy</h2></a>
<h3>実装内容</h3>
スクラムマスター
<br>
商品購入ページ_マークアップ
<br>
商品出品機能_サーバーサイド&単体テスト
<br>
商品購入機能_サーバーサイド
<br>
クレジットカード登録（Payjp)
<br>
クレジットカード情報表示(Payjp)

# サイトURL（Basic認証キー）
URL:<a href="http://18.180.239.6/">http://18.180.239.6/</a>

<h3>ID/Pass</h3>
・ID：73g
<br>
・Pass:furima

## テスト用アカウント等
<h3>購入者用</h3>
・メールアドレス：buyer@gmail.com
<br>
・パスワード：1111111

<h3>購入者用カード情報</h3>
・番号：4242424242424242
<br>
・期限：05/20
<br>
・セキュリティコード：123

<h3>出品者用</h3>
・メールアドレス：seller@gmail.com
<br>
・パスワード：1111111

# 73期_Gチーム_フリーマーケットアプリ DB設計
## ER図
![フリマアプリ ER 図 のコピー - データベース ER 図 (1)](https://user-images.githubusercontent.com/62546632/81934613-34644200-962a-11ea-9cee-8b74d386eb7f.png)
## usersテーブル
|Column|Type|Options|
|------|----|-------|
|family_name|string|null: false|
|first_name|string|null: false|
|family_name_kana|string|null: false|
|first_name_kana|string|null: false|
|birthday|date||
|nickname|string|null: false|
|icon_image|string||
|email|string|false, unique: true|
|password|string|null: false|
|profile|text||
|phone_authy|string|null: false, unique: true, limit: 11|
### Association
- has_one: address
- has_many: cards, dependent: :destroy
- has_many: comments
- has_many :likes
- has_many :items, foreign_key: "saler_id", class_name: "Item"
- has_many :items, foreign_key: "buyer_id", class_name: "Item"

## addressesテーブル
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|postal_code|string|null: false|
|prefecture_id|integer|null: false|
|city|string|null: false|
|block|string||
|building|string||
### Association
- belongs_to :user
- belongs_to_active_hash :prefecture

## cardsテーブル(gem 'payjp'を使用)
|Column|Type|Options|
|------|----|-------|
|user|references|null: false, foreign_key: true|
|customer_id|string|null: false|
|card_id|string|null: false|
### Association
- belongs_to :user

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|seller_id|integer|foreign_key: true|
|name||string|null: false, unique: true, index:true|
|category|references|null: false, foreign_key: true|
|brand|string||
|price|integer|null: false|
|description|text|null: false|
|condition|string|null: false|
|delivery_charge|string|null: false|
|prefecture_id|integer|null: false|
|delivery_day|string|null: false|
|size|string|null: false|
|buyer_id|integer|foreign_key: true|
### Association
- has_many: comment
- has_many: likes, dependent: :destroy
- has_many: images, dependent: :destroy
- belongs_to_active_hash :prefecture
- belongs_to :buyer, class_name: "User"
- belongs_to :seller, class_name: "User"
- belongs_to :category
- belongs_to_active_hash :prefecture

## imagesテーブル
|Column|Type|Options|
|------|----|-------|
|image|strig|null: false|
|item|references|foreign_key: true|
### Association
- belongs_to :item

## categoriesテーブル(ancestry使用)
|Column|Type|Options|
|------|----|-------|
|name|strig|null: false|
|ancestry|||
### Association
- has_many: items
- has_ancestry

## likesテーブル
|Column|Type|Options|
|------|----|-------|
|item|references|null: false, foreign_key: true|
|user|references|null: false, foreign_key: true|
### Association
belongs_to :item
belongs_to :user

## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|text|text|null: false|
|item|references|null: false, foreign_key: true|
|user|references|null: false, foreign_key: true|
### Association
belongs_to :item
belongs_to :user

## prefectureモデル(active_hash使用)
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
