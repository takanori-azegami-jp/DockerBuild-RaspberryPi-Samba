# docker-rpi-samba
RaspberryPi(64bit)にDockerでWindows共有のSambaファイルサーバを構築

## 環境
- kernel：Linux ホスト名 5.15.32-v8+ #1538 SMP PREEMPT Thu Mar 31 19:40:39 BST 2022 aarch64 GNU/Linux
- サーバOS：Debian GNU/Linux 11 (bullseye)
- クライアントOS：Windwos11 Pro 22H2


## 開放ポート
- 137/udp
- 138/udp
- 139/tcp
- 445/tcp

## ID、PASSの変更
`Dockerfile`の`samba-user`と`samba-pass`を変更する
~~~
# ユーザ登録
RUN adduser --disabled-password --gecos "" samba-user
RUN echo "samba-user:samba-pass" | chpasswd
RUN printf 'samba-pass\nsamba-pass\n' | pdbedit -a -t -u samba-user
~~~

## コンテナ起動
docker-compose.ymlを配置したフォルダに移動して実行
~~~
$ docker-compose up -d --build
~~~

## Windowsからの接続方法
省略

## 参考サイト
- [Dockerでイメージ作成してsamba立ち上げる)](https://qiita.com/hasegit/items/3cf5dbd8951d8f236d54)
- [sambaを導入してファイルサーバを構築する手順（インストールから設定方法まで）](https://snowsystem.net/other/linux/samba-install/)
- [smb.conf - 日本Sambaユーザ会](http://www.samba.gr.jp/project/translation/current/htmldocs/manpages/smb.conf.5.html)
- [Dockerと戯れる(第一幕/dockerでsambaを構築する)](https://qiita.com/skrb_hs/items/a9a7610333beffd24cdc)
