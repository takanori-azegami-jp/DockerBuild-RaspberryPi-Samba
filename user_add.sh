#!/bin/sh

while read line
do
	#リストを１行ずつ読み込んでIDとパスワードを変数に格納
	usrname=`echo $line | awk '{print $1}'`
	passwd=`echo $line | awk '{print $2}'`
	#ユーザ登録
	adduser --disabled-password --gecos "" "$usrname"
	echo "${usrname}:${passwd}" | chpasswd
	echo -e "$passwd\n$passwd" | pdbedit -a -t -u $usrname
done < ./user.list

# リスト消去
rm ./user.list
