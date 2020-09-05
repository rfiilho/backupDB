#!/bin/bash

data=`date +%Y%m%d`

#Configurações do banco
host="localhost"
user="root"
passwd="passwd"

#Bases de dados para backup
databases=(users posts logs)

#Diretório arquivos SQL
dir_sql = "/var/lib/mysql/"

#Diretório arquivo de LOG
arq_log=/var/log/bckdb/$data.log

#Backup databases
for db in "${databases[@]}";
do
	echo "================================" >> $arq_log
	echo "     INICIO BACKUP DATABASE     " >> $arq_log
	date >> $arq_log
	mysqldump -h $host -u $user -p $passwd $db > $dir_sql$db\_$data.sql
	echo "================================" >> $arq_log
	echo "       FIM BACKUP DATABASE      " >> $arq_log
done

#Compactação databases
for f in $dir_sql*.sql;
do
	echo "================================" >> $arq_log
	echo "     INICIO COMPAC DATABASE     " >> $arq_log
	date >> $arq_log
	tar -cvzf $f.tar.gz $f >> $arq_log
	if [ $? -eq 0 ];
	then
			rm $f;
	fi
	echo "================================" >> $arq_log
	echo "       FIM COMPAC DATABASE      " >> $arq_log
done
