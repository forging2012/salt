include:
  - php.install

php_ini:
  file.managed:
    - name: /usr/local/webservers/php5_5_29/etc/php.ini
    - source: salt://php/files/php.ini
    - require:
      - cmd: php_complite

php_conf:
  file.managed:
    - name: /usr/local/webservers/php5_5_29/etc/php-fpm.conf
    - source: salt://php/files/php-fpm.conf

php_fastcgi_service:
  cmd.run:
    - names:
      - /bin/cp /usr/src/php-5.5.29/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm 
    - unless: test -e /etc/init.d/php-fpm
  service.running:
    - name: php-fpm
    - enable: True
    - reload: True
    - require:
      - cmd: php_fastcgi_service
    - watch:
       - file: /usr/local/webservers/php5_5_29/etc/php-fpm.conf
       - file: /usr/local/webservers/php5_5_29/etc/php.ini

check_php-fpm_status:
  file.managed:
    - name: /usr/src/check_php-fpm_status.sh
    - source: salt://php/files/check_php-fpm_status.sh
    - user: root
    - mode: 777
  cmd.run:
    - cwd: /usr/src
    - name: /bin/bash check_php-fpm_status.sh
