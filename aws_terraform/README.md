# ディレクトリ構成

ディレクトリ構成は以下の通り。

```
```

## aws_terraform

Terraform 作業スペース。

## aws_terraform/backend_cfn

tfstate保存用S3バケットを生成するためのCFn Stackファイル。

# Preparation

## 環境変数

```
export AWS_PROFILE=hogehoge
```

Assumed Role の名前付きプロファイルを使うときは `AWS_SDK_LOAD_CONFIG` 変数を真値に設定する。

```
export AWS_SDK_LOAD_CONFIG=1
```

もしくは、以下のようにクレデンシャルを設定する (非推奨)

```
export AWS_ACCESS_KEY_ID=xxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

# Usage

## tfstate配置用S3バケット作成

backend_cfn/parameter.json を編集する。

- `Parameters[0].Parametervalue` をAWS内で一意なバケット名に変更する

./  terraform.tf を編集する

- `terraform{}` の `bucket` 属性を先ほど編集したバケット名に変更する

backend_cfn ディレクトリ内で以下を実行する。

```
aws cloudformation create-stack --template-body file://s3_bucket.yaml --stack-name hoge-cloud-tfstate-s3bucket --cli-input-json file://parameter.json
```

## Terraform 実行

aws_terraformディレクトリで `terraform` コマンドを実行する。

```
terraform init
terraform validate
terraform plan
terraform apply
```

# Issue

* S3バケット名をハードコードしているので、いい具合に変えられるようにしたい
    * `terraform {}` ブロックは変数が使えないので、ローカルで生成する仕組みにするしかないかな。