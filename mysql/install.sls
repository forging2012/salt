#install source mysql
mysql_source:
  file.managed:
    - name: /usr/src/mysql-5.6.19.tar.gz
    - unless: test -e /usr/src/mysql-5.6.19.tar.gz
    - source: salt://mysql/files/mysql-5.6.19.tar.gz

#tar source mysql
extract_mysql:
  cmd.run:
    - cwd: /usr/src
    - names:
        - tar xf mysql-5.6.19.tar.gz
    - require:
        - file: mysql_source
    - unless: test -d mysql-5.6.19

#useradd for mysql
mysql_user:
  user.present:
    - name: mysql
    - uid: 1024
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin

#mysql pkg.install
mysql_pkg:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - autoconf
      - automake
      - openssl
      - openssl-devel
      - zlib
      - zlib-devel
      - ncurses-devel
      - libtool-ltdl-devel
      - cmake
# mkdir 
mysql_dir:
  cmd.run:
    - name: mkdir -p /data/mysql/{data,,log,relaylog,binlog} && mkdir /usr/local/webservers && chown mysql:mysql -R /data/mysql
    - unless: test -d /data/mysql

#mysql source install
mysql_commpile:
  cmd.run:
    - cwd: /usr/src/mysql-5.6.19
    - names:
       - cmake -DCMAKE_INSTALL_PREFIX=/usr/local/webservers/mysql-5.6.19 -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DENABLE_DOWNLOADS=1 -DWITH_EXTRA_CHARSETS_STRING=all -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1
       - make -j4
       - make install
    - require:
       - cmd: extract_mysql
       - pkg: mysql_pkg
    - unless: test -d /usr/local/webservers/mysql-5.6.19
