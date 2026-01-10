#!/bin/sh
set -e

WP_PATH=/var/www/wordpress

echo "Waiting for MariaDB..."

until mariadb -h mariadb -u"$DB_USER" -p"$DB_PASSWORD" wordpress -e "SELECT 1" >/dev/null 2>&1; do
  echo "MariaDB not ready yet..."
  sleep 2
done

echo "MariaDB is ready!"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
  wp core download --locale=fr_FR --path="$WP_PATH" --allow-root

  wp config create \
    --dbname="wordpress" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="mariadb" \
    --path="$WP_PATH" \
    --allow-root

  wp core install \
    --url="mleproux.42.fr" \
    --title="INCEPTION WORDPRESS" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_MAIL" \
    --skip-email \
    --path="$WP_PATH" \
    --allow-root
fi

wp user get "$WP_USER" --path="$WP_PATH" --allow-root >/dev/null 2>&1 || \
wp user create "$WP_USER" "$WP_USER_MAIL" \
  --user_pass="$WP_USER_PASSWORD" \
  --role=subscriber \
  --path="$WP_PATH" \
  --allow-root

mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 -F
