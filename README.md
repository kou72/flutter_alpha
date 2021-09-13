# アプリの紹介

ハッカソン部で[勉強会プラットフォーム(の簡易版)](https://flutter-alpha-09131.web.app/#/)を作りました！  

次のような機能を実装しています。
1. 適当なメールアドレスでアカウント作成
2. イベントの確認と申し込み
3. マイイベントの作成、編集、削除

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/%E3%83%87%E3%83%A2%E5%8B%95%E7%94%BB.gif)

開発言語はFlutter/Dart、ホスティング/認証/DBにFirebaseを使っています。  
Flutter×Firebaseは少ない記述量でモバイルアプリを作る事のできる有名な組み合わせです。

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0%E6%A6%82%E8%A6%81%E5%9B%B3.png)

# この部屋で話したいこと

今回はこのアプリを題材に主にGUIアーキテクチャの話をできればと思います。

- 今回のアプリはMVVMモデルを参考に作っています
- MVVMの使い方ちょっと違うかも
- (逆に)ここの使い方は正しいよ！
- 現場であまりこういう書き方は見ないかも、、、
- (逆に)現場でもこの書き方はよく見るし、一般的な設計だと思うよ！

などなど。  

他にも聞きたいことがあれば何でも聞いてください！  
部屋にいる皆さんからも色々な意見が聞けると嬉しいです。

- こういう設計にして後々困ったことになったよ
- この本・記事が参考になったよ！
- アーキテクチャ設計難しいの分かる～～～
 
などなど

# GUIアーキテクチャ

## GUIアーキテクチャとは

アプリを開発する時の重要な考え方として、**「見た目(UI)」に関するコードと「処理」に関するコードは分けましょう**、というものがあります。  
この考え方に沿った色々なアーキテクチャが考え出されており、それらのことを**GUIアーキテクチャ**と呼びます。  

今回は数あるGUIアーキテクチャのうち**MVVMモデル**を参考に設計しました。

## MVVMモデルとは

MVVMモデルとはコードの役割をView、ViewModel、Modelの3つに分割するアーキテクチャです。

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/MVVM.png)

参考：[iOSアプリ設計パターン入門](https://peaks.cc/books/iOS_architecture)サンプル

- View  
アプリの「見た目」に関するコードが記述されます。

- Model  
アプリの「処理」に関するコードが記述されます。  

- ViewModel  
ViewとModelの仲介役になります。  

## フォルダ構成

Flutterでは「lib」というフォルダの中にコードを記述していきます。  
今回はMVVMモデルを表現するために、次のようなディレクトリ構成にしています。

---

flutter_alpha/lib  
│  main.dart  
│  
├─:file_folder:**view**  
│  │  event_detail_page.dart  
│  │  event_list_page.dart  
│  │  my_event_detail_page.dart  
│  │  my_event_list_page.dart  
│  │  signin_page.dart  
│  │  
│  └─:file_folder:components  
│  
├─:file_folder:**model**  
│      auth_model.dart  
│      events_model.dart  
│      guests_model.dart  
│  
├─:file_folder:**view_model**  
│      event_detail_view_model.dart  
│      my_event_detail_view_model.dart  
│      signin_view_model.dart  

---

## Q. 「マイイベントリストページ」と「マイイベント詳細ページ」のコードはそれぞれどこに書くべきでしょうか？

「マイイベントリストページ」と「マイイベント編集ページ」について、UI、ステータス、処理を列挙しました。  
皆さんならそれぞれの処理をView、ViewModel、Modelにどのように分割するでしょうか？

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/Q%E3%83%9E%E3%82%A4%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88.png)

機能  

- マイイベントリストページ：自分が作成したイベントを一覧で表示する
- マイイベント詳細ページ：作成したイベントを編集する

## A. このアプリでは次のような設計にしています。

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/A%E3%83%9E%E3%82%A4%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88.png)

意識した点

- ViewModelはViewに対応するようにファイル分割
- Modelはバックエンド(今回はFirebase)に対応するようにファイル分割
- View側からバックエンドは見えないようにする
- ViewからModelを参照している　←許される？


## Q. 「イベントリストページ」と「イベント詳細ページ」のコードはそれぞれどこに書くべきでしょうか？

「イベントリストページ」と「イベント編集ページ」について、UI、ステータス、処理を列挙しました。  
皆さんならそれぞれの処理をView、ViewModel、Modelにどのように分割するでしょうか？

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/Q%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88.png)

機能  

- イベントリストページ：全てのイベントを一覧で表示するページ
- イベント詳細ページ：イベントの詳細を確認し、申し込みを行うページ

## A. このアプリでは次のような設計にしています。

![](https://github.com/kou72/flutter_alpha/raw/master/README_image/A%E3%82%A4%E3%83%99%E3%83%B3%E3%83%88.png)

意識した点

- ViewModelはViewに対応するようにファイル分割
- Modelはバックエンド(今回はFirebase)に対応するようにファイル分割
- 「更新ボタンを押せるか」判定をViewModelに集約してViewにとってシンプルな構成

## 最後に

皆様レビュー頂きましてありがとうございました。  
気になった点があれば後日でも遠慮なく言ってください、大変ありがたいです。  
PRもお待ちしております～。
