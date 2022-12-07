#!/bin/bash
# mail: itybku@139.com
# site: www.361way.com

export  PATH=/usr/local/bin/:$PATH

if [ -d /srv/wordpress ];then
   rm -rf /var/www/html/index.html
   mv /srv/wordpress/* /var/www/html/
   mv /srv/wordpress/.htaccess /var/www/html/
   mv /srv/wp /usr/local/bin/
   chmod +x /usr/local/bin/wp
   rm -rf /srv/wordpress/
   mv /srv/env /root/
   source /root/env
fi



if [ ! -s /var/www/html/wp-config.php ];then
	wp core config --dbname=$STAGE_WORDPRESS_DB_NAME --dbuser=$STAGE_WORDPRESS_DB_USER --dbpass=$STAGE_WORDPRESS_DB_PASSWORD --dbhost=$STAGE_WORDPRESS_DB_HOST --allow-root --path=/var/www/html/

	#wp core install --url="http://127.0.0.1"  --title="Blog Title" --admin_user="admin" --admin_password="password" --admin_email="itybku@139.com"  --allow-root --path=/var/www/html/
	wp core install --url=$URL  --title=$Title --admin_user=$Admin --admin_password=$PASSWORD --admin_email=$Email  --allow-root --path=/var/www/html/

	#wp config set WP_REDIS_HOST "127.0.0.1" --allow-root --path=/var/www/html/
	#wp config set WP_REDIS_PORT 6379 --allow-root --path=/var/www/html/
	#wp config set WP_REDIS_PASSWORD password --allow-root --path=/var/www/html/

	if [ $REDIS_HOST ];then

		wp config set WP_REDIS_HOST $REDIS_HOST --allow-root --path=/var/www/html/
		
		if [ $REDIS_PORT ];then
			wp config set WP_REDIS_PORT $REDIS_PORT --allow-root --path=/var/www/html/
		else
			echo "Use the Redis define port 6379"
			wp config set WP_REDIS_PORT 6379 --allow-root --path=/var/www/html/
		fi
		
		if [ $REDIS_PASSWORD ];then
			wp config set WP_REDIS_PASSWORD $REDIS_PASSWORD --allow-root --path=/var/www/html/
		else
			echo "Redis cache use the empty password"
		fi
		
		wp plugin install redis-cache --activate
		
	else
		echo "REDIS_HOST parameter didn't set, didn't need configure the Redis cache"
	fi

fi

chown -R www-data:www-data /var/www/html/*
/etc/init.d/apache2 start
tail -f /var/log/apache2/access.log
