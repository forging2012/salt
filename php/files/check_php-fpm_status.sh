#!/bin/bash
STATUS=`/etc/init.d/php-fpm status`

if [[ $STATUS == "php-fpm is stopped" ]] ;then

	/etc/init.d/php-fpm start &>/dev/null
	echo "Service php-fpm start finished...."
else
     
	echo "Service php-fpm is already start....."

fi
