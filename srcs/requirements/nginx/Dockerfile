FROM alpine:3.23.2

RUN apk update
RUN apk add nginx openssl

COPY ./nginx.conf /etc/nginx/nginx.conf
WORKDIR /var/www/html

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=Normandie/L=Le Havre/O=42/OU=42LeHavre/CN=mleproux.42.fr"

CMD ["nginx", ["-g"] ,"daemon off"]