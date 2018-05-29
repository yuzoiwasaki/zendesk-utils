# zendesk-utils

## delete_duplicate_tickets

Zendesk上にある重複チケットをキーワードを指定して削除する

### 動作環境

Macを想定（バージョン 10.12.6で確認）

### 事前準備

内部的に[jq](https://stedolan.github.io/jq/)を使うので入ってなければ入れておく

```sh
brew install jq
```

環境変数を設定

```sh
export ZENDESK_USERNAME=foo@example.com
export ZENDESK_PASSWORD=password
export ZENDESK_SUBDOMAIN=bar
```

### 使い方

引数で指定したキーワードで検索しヒットしたチケットを最新の一つを残して削除します

```sh
sh ./delete_duplicate_tickets.sh baz
```

`--all` オプションを指定すると全て削除されます

```sh
sh ./delete_duplicate_tickets.sh --all baz
```