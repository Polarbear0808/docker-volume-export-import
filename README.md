# docker-volume-export-import
Docker Volumeのエクスポートとインポートの実験

## 01.MySQL
`start_mysql.sh`を実行する。

```
$ bash start_mysql.sh
```

コンテナが起動したことを確認する。

```
$ docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                 NAMES
9ca6aaae07b5   mysql:8.0.26   "docker-entrypoint.s…"   6 minutes ago   Up 6 minutes   3306/tcp, 33060/tcp   mysql1
```

現在のスキーマ一覧を確認する。

```
$ docker exec mysql1 mysql -u root -ppass -e 'show databases;'
information_schema
mysql
performance_schema
sys
```

この時点での`/var/lib/mysql`のバックアップを取得する。

```
$ bash ./backup_volume.sh backup_before
```

`backup_before.tar`が作成される。

MySQLの内容を更新する。

```
$ docker exec mysql1 mysql -u root -ppass -e 'create database sample;'
```

`sample`なるスキーマがMySQLに作成されたことを確認する。

```
$ docker exec mysql1 mysql -u root -ppass -e 'show databases;'
information_schema
mysql
performance_schema
sample
sys
```

もう一度バックアップを取得する。

```
$ bash ./backup_volume.sh backup_after
```

`backup_after.tar`が作成される。

`mysql1`コンテナと`myvol1`ボリュームを削除する。

```
$ docker stop mysql1 && docker rm mysql1
$ docker volume rm myvol1
```

`mysql1`コンテナを再度開始する。

```
$ bash start_mysql.sh
```

現在のスキーマ一覧を確認する。`sample`がないことを確認する。

```
$ docker exec mysql1 mysql -u root -ppass -e 'show databases;'
information_schema
mysql
performance_schema
sys
```

リストアを実行する。

```
$ bash restore_volume.sh backup_after
```

現在のスキーマ一覧を確認する。`sample`があることを確認する。

```
$ docker exec mysql1 mysql -u root -ppass -e 'show databases;'
information_schema
mysql
performance_schema
sample
sys
```

## Tips
### `--volumes-from`
バックアップとリストアで鍵になっているのは、`docker run`のオプションのひとつとして指定されている`--volumes-from`です。

```
$ docker run --help

      --volumes-from list              Mount volumes from the
                                       specified container(s)
```

コンテナ名を指定して、そのコンテナにアタッチされているボリュームにマウントします。
`-v`等で一つひとつ指定しなくても、あるコンテナが使っているボリュームをまるっと使うという指定ができるわけですね。

## `tar`の展開先
`tar`コマンドは、基本的にコマンドを実行したときのカレントディレクトリに内容物を展開します。
`busybox`等を使ってバックアップとリストアを行う際は、以下のことに気をつけるとうまくいきます。
- バックアップ側：ルートからの絶対パスで指定して`tar`ファイルを作成する
- リストア側：ルートで`tar`ファイルを展開する

リストア側で`tar`コマンドの`-C`オプションを使い展開先を指定することもできます。
ルート直下に影響を及ぼす可能性があると困る場合は、`-C`オプションを使いましょう。
## 参考
- [Dockerのデータボリュームをバックアップ/リストアする](https://noumenon-th.net/programming/2019/04/04/backup/)  
- [Use volumes
](https://docs.docker.com/storage/volumes/)

