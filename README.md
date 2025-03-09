## 概要

窓口業務のうち、学生からの書類申請と質問対応の業務を電子化したポータルサイト。

## 背景

窓口業務が事務の職員の方々で負担になっている。特に負担になっているのが、学生からの書類申請と質問対応だ。

現在、書類の申請は事務側で紙の書類を校内支援システムに入力している。しかし、学生から事務室への申請は、未だに紙のままである。誤字脱字や書類不備が発生し、時間がかかっている。書類内容の打ち込みも負担となっている。

また、学生からの質問対応も電子化への要望が高い。何度も同じ質問が寄せられたり、質問への対応を知っている職員がいない時に回答できないといったことがあるからだ。

## 目的

窓口業務の一部を電子化することで、事務室の職員の方々の業務を軽減させる。また、学生がいつでもどこでも窓口機能を使えるようにする。

## 対象

- 事務室の職員の方々
- 窓口を利用する学生

## 機能

申請画面では、窓口前でもらわなければならなかった書類のPDFデータをダウンロード可能である。

Q&A一覧・検索では、過去に寄せられた質問を検索でき、見つからない場合はフォームを通じて質問できる。

ChatGPTで検索アシストを行う。

News欄では、必要な書類や奨学金などのイベントが提示される。

校内の道案内では、研究室やゼミナール室の場所や、各授業が開催されている部屋を案内する。

また、OPACへのアクセスも提供される。

優先して実装するのは、「書類申請」「Q&A」である。この二つが事務室から最も求められている機能であるからだ。


## ワイヤーフレーム

Figmaを用いて、ワイヤーフレームを作成した。事務室から肯定的なフィードバックをもらった。

## アーキテクチャ

- 全体
    - Flutterを使って実装する
    - AndroidとiOS向けのネイティブかWeb向けにビルドする
        - Flutterで開発するため、横断的にビルド可能
- 書類申請
    - 申請書類をmicroCMSを利用して設定
- Q&A
    - microCMSを使用して、Q&Aデータベースを構築
    - ユーザーが質問を投稿し、管理者が回答を追加する仕組み
        - Formに質問を記入
        - 質問に対する回答を、事務室側がメールで送信。また、回答データをデータベースに追加
- 検索アシスト
    - GPTが検索をアシストする

## 類似システム

[Zendeskで顧客視点のサポート体制を構築](https://www.zendesk.co.jp/lp/brand/?utm_source=google&utm_medium=Search-Paid&utm_network=g&utm_campaign=SE_AW_AP_JP_JP_N_Sup_Brand_TM_Alpha_D_H&matchtype=e&utm_term=zendesk&utm_content=659834939736&theme=&gad_source=1&gclid=CjwKCAjw57exBhAsEiwAaIxaZlKymrt7soh9BDPjcPJuVK5XyV25WkM-V4mNuuBmEFRHq6riuwBKpxoCQ9EQAvD_BwE&demoStep=personal)

Zendesk。社内Q&Aを作成可能。AIチャットbotを搭載している。

[AI搭載のFAQシステムsAI Search（サイサーチ）は検索せずに回答が見つかる](https://saichat.jp/saisearch/)

sAI Search。上に同じ。寄せられそうな質問を予測する機能を搭載している。

[入社手続き・雇用契約｜SmartHR｜シェアNo.1のクラウド人事労務ソフト](https://smarthr.jp/function/agreement/?utm_source=google&utm_medium=cpc&utm_campaign=search-06-other&utm_term=c-%E6%9B%B8%E9%A1%9E%20%E4%BD%9C%E6%88%90-b&utm_content=125462199357-582736296909&gad_source=1&gclid=CjwKCAjw57exBhAsEiwAaIxaZk3OJ_YEFJP5pPM7-0BtllZifomiBkYMGI4XkqjmTCngPyaMrkvPVBoCA7AQAvD_BwE)

SmartHR。現在使われている紙面と同じ書類を電子的に作成できる。

## 実装計画

### 実装の優先度

1. PDF書類のダウンロード
2. Q&A
3. 書類申請用Form
4. （News欄、校内地図）

### 前半(3週間程度)

1. Figmaで画面イメージを作成
2. FlutterのCI/CD環境を構築
    
    [Continuous delivery with Flutter](https://docs.flutter.dev/deployment/cd#fastlane)
    
3. ダミーデータを使ってUI部分を作り、使用感を確認
4. 事務室の方からUI部分のフィードバックをもらう
5. フィードバックを受け、改良

### 後半(3週間程度)

1. UI部分をリファクタリング
2. ウィジェットのテストを作成
3. データベースの構造を定める
4. バックエンドの処理を作成
5. 事務室の方から全体的なフィードバックをもらう
6. フィードバックを受け、改良

## 参考

[コンテンツに自動付与される値｜microCMSドキュメント](https://document.microcms.io/manual/automatic-grant-fields)

[microCMSに大量コンテンツを登録する方法まとめ](https://blog.microcms.io/how-to-register-a-large-amount-of-content/)

[Flutter アプリのテスト方法  |  Google Codelabs](https://codelabs.developers.google.com/codelabs/flutter-app-testing?hl=ja#0)

---
## 必要な設定

このプロジェクトを実行するためには、Firebaseの設定ファイルが必要です。以下の手順で設定ファイルを取得してください。

1. [Firebase Console](https://console.firebase.google.com/)にアクセスして、プロジェクトを作成します。
2. プロジェクト作成後、以下の設定ファイルをダウンロードします。
   - **Android**: `google-services.json`（Firebaseコンソールの[プロジェクト設定] > [Firebase SDKの設定と構成]でダウンロード）
   - **iOS**: `GoogleService-Info.plist`（Firebaseコンソールの[プロジェクト設定] > [Firebase SDKの設定と構成]でダウンロード）
   
3. それぞれの設定ファイルを、以下の場所に追加します：
   - **Android**: `android/app/` フォルダに `google-services.json` を配置
   - **iOS**: `ios/Runner/` フォルダに `GoogleService-Info.plist` を配置

4. Firebaseの設定ファイルを配置したら、アプリをビルドして実行できます。

## 必要なパッケージ

依存関係をインストールするには、次のコマンドを実行してください：

```bash
flutter pub get
