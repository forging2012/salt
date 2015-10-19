include:
  - mysql.install
# mysql for config
mysql_cnf:
  file.managed:
    - name: /etc/my.cnf
    - user: root
    - mode: 755
    - source: salt://mysql/files/my.cnf
# mysql_service
mysql_service:
  file.managed:
    - name: /usr/src/mysql_init.sh
    - user: root
    - mode: 755
    - source: salt://mysql/files/mysql_init.sh
  cmd.run:
    - names:
        - cd /usr/src && /bin/bash mysql_init.sh
    #    - /sbin/chkconfig --add mysqld
     #   - /sbin/chkconfig --level 35 mysqld on
    #- unless: test -d /data/mysql/data/mysql
    - unless: test -e /usr/src/mysql_init.sh
  service.running:   
    - name: mysqld
    - enable: True
    - reload: True
    - watch:
      - file: /etc/my.cnf
