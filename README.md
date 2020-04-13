# aws-handon-for-bigginers-scalable
AWS Hands-on for Beginners 〜 スケーラブルウェブサイト構築編 〜 をTerraformで構築する

## 対応範囲

Step1 Amazon VPCの作成 から Step5 ELBの作成 までのリソース作成を自動化する。
Step6 以降はWordPressの初期設定が絡むため、省略した。

## ハンズオンとの相違点 

- SGで特定の外部IPからのアクセスのみ許可する

## ToDo

Step6 以降の自動構築

- AMI指定でEC2インスタンスを起動するTerraform設定を aws_terraform とは別に作成する?
- 自動構築できるようにaws_terraformのファイルを分割する
    - ネットワーク, RDS, ALBまでを作る
    - ↑の環境下でAMIを焼く
    - 焼いたAMIを使ってEC2インスタンス+TargetGroup Attachmentを作成する