#nginx.tar.gz 
nginx_source:
  file.managed:
    - name: /usr/src/nginx-1.9.4.tar.gz
    - unless: test -e /usr/src/nginx-1.9.4.tar.gz
    - source: salt://nginx/files/nginx-1.9.4.tar.gz

#nginx_modules
nginx_modules:
  file.managed:
    - name: /usr/src/nginx_modules.tar.gz
    - unless: test -e  /usr/src/nginx_modules.tar.gz
    - source: salt://nginx/files/nginx_modules.tar.gz
  cmd.run:
    - cwd: /usr/src
    - names:
      - tar xf nginx_modules.tar.gz
    - unless: test -d /usr/src/modules

#extract
extract_nginx:
  cmd.run:
    - cwd: /usr/src
    - names:
      - tar xf nginx-1.9.4.tar.gz
    - unless: test -d /usr/src/nginx-1.9.4
    - require:
       - file: nginx_source

#user
nginx_user:
  user.present:
    - name: www
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin 

#nginx_pkg
nginx_pkg:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - openssl-devel
      - pcre-devel
      - zlib-devel

#nginx_compile:
nginx_compile:
  cmd.run:
    - cwd: /usr/src/nginx-1.9.4
    - names:
       - ./configure --user=www --group=www --prefix=/usr/local/webservers/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_sub_module --with-file-aio --add-module=../modules/headers-more-nginx-module --add-module=../modules/ngx_devel_kit --add-module=../modules/set-misc-nginx-module --add-module=../modules/nginx-push-stream-module --with-http_realip_module --with-http_gunzip_module --with-http_gzip_static_module   && make -j4 && make install
    - require:
      - cmd: extract_nginx
      - pkg: nginx_pkg
      - cmd: nginx_modules
    - unless: test -d /usr/local/webservers/nginx
#vhost:
vhost:
  cmd.run:
    - names:
      - mkdir -p /usr/local/webservers/nginx/conf/sites-enabled && chown -R www:www /usr/local/webservers/nginx/conf/sites-enabled
    - require:
      - cmd: nginx_compile
    - unless: test -d /usr/local/webservers/nginx/conf/sites-enabled
  file.managed:
    - name: /usr/local/webservers/nginx/conf/sites-enabled/vhost.conf
    #- unless: test -e /usr/local/webservers/nginx/conf/sites-enabled/vhost.conf
    - source: salt://nginx/files/vhost.conf 
