#php.tar.gz
php_source:
  file.managed:
    - name: /usr/src/php-5.5.29.tar.gz
    - unless: test -e /usr/src/php-5.5.29.tar.gz
    - source: salt://php/files/php-5.5.29.tar.gz

#extract
extract_php:
  cmd.run:
    - cwd: /usr/src
    - names:
      - tar xf php-5.5.29.tar.gz
    - unless: test -d /usr/src/php-5.5.29
    - require:
       - file: php_source
#php_pkg
php_pkg:
  file.managed:
    - name: /usr/src/php_fpm.sh
    - source: salt://php/files/php_fpm.sh
  cmd.run:
    - cwd: /usr/src
    - name: /bin/sh php_fpm.sh
#    - unless: test -e /usr/src/php_fpm.sh
    
#php_complite:
php_complite:
  cmd.run:
    - cwd: /usr/src/php-5.5.29
    - names:
      - ./configure --prefix=/usr/local/webservers/php5_5_29 --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-config-file-path=/usr/local/webserver/php5_5.29/etc --with-jpeg-dir --with-pdo-mysql=mysqlnd --with-freetype-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --without-pear --with-xpm-dir=/usr --with-gd  && make -j4 && make install
    - require:
      - cmd: extract_php
      - cmd: php_pkg
    - unless: test -d /usr/local/webservers/php5_5_29
