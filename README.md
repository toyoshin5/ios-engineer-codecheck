# 株式会社ゆめみ iOS エンジニアコードチェック課題

## 制作物

<p align="center">
  <img src="https://github.com/toyoshin5/ios-engineer-codecheck/assets/43494392/5aaf8087-e862-4d6c-ab5b-2a7f209f086e" alt="altテキスト" width="250px">
  <img src="https://github.com/toyoshin5/ios-engineer-codecheck/assets/43494392/1e3d68e7-0d1e-4d1a-8545-aefd6eb33954" alt="altテキスト" width="250px">
  <img src="https://github.com/toyoshin5/ios-engineer-codecheck/assets/43494392/38ccbac3-757c-48b9-9826-7a7bd80c37f3" alt="altテキスト" width="250px">
</p>

## 課題取り組み内容

### 課題1 ソースコードの可読性の向上

- 過剰に省略された変数名を修正した。
- 変数名をlowerCamelCaseに統一した。
- ViewController名を修正した。
  - ViewController → MainViewController
  - ViewController2 → DetailViewController
- その他、説明が正しくないコメントを修正した。
- 一部のスペースが不適切な箇所を修正した。

### 課題2 ソースコードの安全性の向上

- 暗黙的アンラップ型の変数を通常のOptional型に変更した。
- オプショナルバインディングなどをして強制アンラップを排除した。
- 強制的なダウンキャストを排除した。
- 変数宣言時のデータ型を明記した。
- 配列外参照を防ぐために、配列の外を参照したらnilを返すように修正した。

### 課題3 バグを修正

- StoryboardのAutoLayoutでエラーが発生していたため、修正した。
- 強参照サイクルが発生する恐れのある箇所にweak selfを追加した。
- watchers の値を取得できていない問題を修正した。
  - `search/repositories`APIではwatchersの値を取得できないことが判明(APIの watchers_count は Watcher の数ではありませんでした。)
  - `repos`APIでリポジトリの詳細情報を取得する方針に変更した。
  - 新たなAPIを実装するにあたって、APIクライアントを実装した。

### 課題4 Fat VC の回避

- DetailVCのMainVCへの依存を解消させた。
  - MainVC → DetailVCへの遷移では最低限必要な情報のみを渡した。
- 検索用のAPIクライアントを実装
  - MainVCから通信処理を切り離した。
- `GithubRepoDataSource`を定義
  - MainVCからDataSourceを切り離した。
- UISearchBarDelegateのメソッドはextensionに切り離した。

### 課題5 プログラム構造をリファクタリング

- Storyboardをページごとに分割した。
- 検索結果のレスポンスクラス`RepoItem`をViewのモデルクラスとしても使用していた。
  - 単一責任原則違反の疑いあり？
  - Viewのモデルクラスとして新たに`Repository`を定義することにした。

### 課題6 アーキテクチャを適用

- MVVMアーキテクチャを適用
  - ViewControllerはViewとしての役割に徹するようにした。
  - 今後ViewをSwiftUIに置き換えた際に、ViewModel,Modelはそのまま使えるようにした。
  - Combineを用いて、ViewModelの値をViewが監視できるようにした。

### 課題7 UI をブラッシュアップ

- InsetGroupedのTableViewを採用した。
- LargeTitleを採用した。
- 検索画面にアバター画像、概要文、star数を表示するようにした。
- リポジトリ詳細画面に概要文を表示するようにして、UIを整えた。

### 課題8 新機能を追加

- デフォルトブランチの`README.md`を表示する機能を追加した。

### 課題9 テストを追加

- APIスタブを用いて、APIクライアントのテストを追加した。
- 簡単なUIテストを追加した。

## 使用ライブラリ

- [MarkdownView](https://github.com/keitaoouchi/MarkdownView) (Swift Package Manager)
  - README.mdを表示するために使用

# 課題説明

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の説明を詳しく読んだ上で課題を取り組んでください。

新卒／未経験者エンジニアの場合、本リファクタリングの通常課題の代わりに、[新規アプリ作成の特別課題](https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud)も選択できますので、ご自身が得意と感じる方を選んでください。特別課題を選んだ場合、通常課題の取り組みは不要です。新規アプリ作成の課題の説明を詳しく読んだ上で課題を取り組んでください。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要更新時点では Xcode 15.2）
- Swift：基本最新の安定版（本概要更新時点では Swift 5.9）
- 開発ターゲット：基本最新の安定版（本概要更新時点では iOS 17.2）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |

課題 Issueをご自身のリポジトリーにコピーするGitHub Actionsをご用意しております。  
[こちらのWorkflow](./.github/workflows/copy-issues.yml)を[手動でトリガーする](https://docs.github.com/ja/actions/managing-workflow-runs/manually-running-a-workflow)ことでコピーできますのでご活用下さい。

課題が完成したら、リポジトリーのアドレスを教えてください。

## 参考情報

提出された課題の評価ポイントについても詳しく書かれてありますので、ぜひご覧ください。

- [私が（iOS エンジニアの）採用でコードチェックする時何を見ているのか](https://qiita.com/lovee/items/d76c68341ec3e7beb611)
- [CocoaPods の利用手引き](https://qiita.com/ykws/items/b951a2e24ca85013e722)
- [ChatGPT (Model: GPT-4) でコードリファクタリングをやってみる](https://qiita.com/mitsuharu_e/items/213491c668ab75924cfd)

ChatGPTなどAIサービスの利用は禁止しておりません。  
利用にあたって工夫したプロンプトやソースコメント等をご提出頂くと加点評価する場合がございます。 (減点評価はありません)
