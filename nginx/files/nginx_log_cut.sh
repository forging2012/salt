#!/bin/bash

#设置日志文件存放目录
logs_path="/var/log/"

#设置pid文件
pid_path="/usr/local/webservers/nginx/nginx.pid"

if [ -d /var/log/nginx_cut_log/ ];then
   mkdir /var/log/nginx_cut_log -p
fi

#重命名日志文件
mv ${logs_path}access_sctux.log ${logs_path}nginx_cut_log/access_sctux_$(date -d "yesterday" +"%F-%T").log 
#向nginx主进程发信号重新打开日志
kill -USR1 `cat ${pid_path}`

