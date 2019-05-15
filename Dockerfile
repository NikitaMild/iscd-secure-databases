FROM ubuntu:bionic

# Install mysql and deps
RUN apt-get update && apt-get install libaio1 libnuma1 openssl -y
RUN mkdir /usr/local/mysql
COPY mysql /usr/local/mysql

# Mysql permissions configuration
RUN groupadd mysql
RUN useradd -r -g mysql mysql
RUN chown mysql:mysql /usr/local/mysql
RUN chmod 754 /usr/local/mysql

# Install mysql configs
RUN mkdir /etc/mysql
COPY instance1.cnf /etc/mysql/
RUN mkdir -p /var/mysql/datadir1
RUN chown --recursive mysql:mysql /var/mysql
RUN chmod 770 /var/mysql/datadir1

# Install mysql ssl stuffs
COPY certs/ca.crt /var/mysql/ca.crt
COPY certs/server.crt /var/mysql/server.crt
COPY certs/server-key.pem /var/mysql/server-key.pem
RUN chmod 600 /var/mysql/ca.crt /var/mysql/server.crt /var/mysql/server-key.pem

# Mysql primary configuration
RUN /usr/local/mysql/bin/mysqld --defaults-file=/etc/mysql/instance1.cnf --initialize-insecure --user=mysql --skip-name-resolve
EXPOSE 3306

# Supervisor installation and configuration
RUN mkdir /opt/run
COPY supervisor.sh /usr/local/bin/supervisor.sh
RUN chown mysql:mysql /usr/local/bin/supervisor.sh
RUN chmod 544 /usr/local/bin/supervisor.sh

# starter script installation
COPY ./run /opt/run
RUN chown mysql:mysql /opt/run/*
RUN chmod 544 /opt/run/*

ENTRYPOINT ["/usr/local/bin/supervisor.sh"]
