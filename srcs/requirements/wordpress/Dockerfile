#Using Debian because I had trouble with Alpine
FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget php php-fpm php-mysql mariadb-client

# RUN wget https://fr.wordpress.org/wordpress-6.9-fr_FR.tar.gz -P /var/www

# WORKDIR /var/www
# RUN tar -xzf wordpress-6.9-fr_FR.tar.gz
# RUN rm wordpress-6.9-fr_FR.tar.gz
# RUN	chown -R root:root /var/www/wordpress

WORKDIR /
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/wordpress && chown www-data:www-data /var/www/wordpress
RUN chmod -R 755 /var/www/wordpress

COPY tools/init_wp.sh /init_wp.sh
RUN chmod +x /init_wp.sh
ENTRYPOINT ["/init_wp.sh"]
