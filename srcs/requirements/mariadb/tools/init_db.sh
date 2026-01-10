#!/usr/bin/env sh
set -e

if [ ! -d "/var/lib/mysql/wordpress" ]; then
    echo "Initializing database..."

    mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    for i in $(seq 1 30); do
        if mysqladmin ping --socket=/tmp/mysql_init.sock --silent 2>/dev/null; then
            echo "MariaDB is ready for configuration!"
            break
        fi
        sleep 1
    done

    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    kill "$pid"
    wait "$pid"
fi

exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
