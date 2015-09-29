#{% set nginx_user = 'www' %} #定义nginx用户

include:
  - nginx.install

#nginx配置
nginx_conf:
  file.managed:
    - name: /usr/local/webservers/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
 #   - template: jinja
 #   - defaults:
  #    nginx_user: {{nginx_user}}  #这里使用jinja模板，会在nginx.conf中替换

#服务管理
nginx_service:
  file.managed:
    - name: /etc/init.d/nginx
    - user: root
    - mode: 755
    - source: salt://nginx/files/nginx
#  cmd.run:
#    - names:
#       - /sbin/chkconfig --add nginx
#       - /sbin/chkconfig --level 35 nginx on
#    - unless: /sbin/chkconfig --list nginx
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: /usr/local/webservers/nginx/conf/nginx.conf
      - file: /usr/local/webservers/nginx/conf/sites-enabled/*.conf

#nginx日志切割及计划任务
nginx_log_cut:
  file.managed:
    - name: /usr/local/webservers/nginx/nginx_log_cut.sh
    - user: root
    - mode: 755
    - source: salt://nginx/files/nginx_log_cut.sh
  cron.present:
    - name: /usr/local/webservers/nginx/nginx_log_cut.sh
    - user: root
    - minute: 10
#    - hour: 0
    - require:
      - file: nginx_log_cut
  cmd.run:
#创建虚拟主机根目录及测试文件
    - name: mkdir -p /home/sctux && echo -e "<?php\n\t\tphpinfo()\n?>" > /home/sctux/index.php
    - unless: test -e /home/sctux/index.php
