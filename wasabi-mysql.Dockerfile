FROM mysql:8.0.13

ARG MYSQL_DATABASE
ARG MYSQL_HOSTNAME=mysql
ARG MYSQL_PORT
ARG MYSQL_ROOT_PASSWORD

ENV MYSQL_DATABASE=${MYSQL_DATABASE} \
    MYSQL_HOSTNAME=${MYSQL_HOSTNAME} \
    MYSQL_PORT=${MYSQL_PORT} \
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

CMD mysql --silent \
    --host=${MYSQL_HOSTNAME} \
    --port=${MYSQL_PORT} \
    --database=${MYSQL_DATABASE} \
    --user=root \
    --password=${MYSQL_ROOT_PASSWORD} \
    --execute='\
        SET GLOBAL log_bin_trust_function_creators = 1;\
        SET @@GLOBAL.log_bin_trust_function_creators = 1;'
