FROM ubuntu:bionic

RUN apt-get update && apt-get install libaio1 libnuma1 openssl -y
RUN mkdir /usr/local/mysql
COPY mysql /usr/local/mysql

RUN groupadd mysql
RUN useradd -r -g mysql mysql
RUN chown mysql:mysql /usr/local/mysql
RUN chmod 754 /usr/local/mysql

RUN /usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql
EXPOSE 3306

USER mysql
ENTRYPOINT ["/usr/local/mysql/bin/mysqld"]
