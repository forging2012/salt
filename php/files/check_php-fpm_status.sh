#!/bin/bash
STATUS=`/etc/init.d/php-fpm status`

if [[ $STATUS == "php-fpm is stopped" ]] ;then

	/etc/init.d/php-fpm start
   
   ss -tunl | grep ":9000" &>/dev/null
   
   if [ $? -eq 0 ] ;then

	echo "Service php-fpm start finished...."
   fi

else
	echo "Service php-fpm is already start....."

fi
