CONTAINER = iscdsecuredatabases_ubuntu-mysql_1
UNIT = ubuntu-mysql
STARTERS = run/start_instance.sh
OPTIONS = instance1.cnf

.PHONY: run
run: dummy/docker dummy/supervisor.sh dummy/starters dummy/options
	docker-compose up

.PHONY: build
build: dummy/docker dummy/supervisor.sh dummy/starters dummy/options

.PHONY: kill
kill:
	docker-compose exec -u root $(UNIT) /usr/local/mysql/bin/mysqladmin shutdown -S /var/mysql/socket1

.PHONY: shell
shell:
	docker-compose exec -u root $(UNIT) /bin/bash

.PHONY: connect
connect:
	docker-compose exec -u root $(UNIT) /usr/local/mysql/bin/mysql -S /var/mysql/socket1

.PHONY: run-*.sql
run-%.sql: %.sql
	docker cp $< $(CONTAINER):/tmp/$<
	docker exec -u root $(CONTAINER) sh -c '/usr/local/mysql/bin/mysql -t -v -S /var/mysql/socket1 </tmp/$<'

dummy/starters: $(addprefix dummy/,$(STARTERS))
	touch dummy/starters
dummy/options: $(addprefix dummy/,$(OPTIONS))
	touch dummy/options

dummy/docker: Dockerfile docker-compose.yml mysql $(CACERT) $(SERVER_CERT) $(SERVER_KEY) | dummy
	docker-compose build
	touch dummy/docker
	touch dummy/supervisor.sh

dummy/supervisor.sh: supervisor.sh | dummy
	docker cp -a $< $(CONTAINER):/usr/local/bin/$<
	touch $@

dummy/run/%.sh: run/%.sh | dummy/run
	docker cp -a $< $(CONTAINER):/opt/$<
	touch $@

dummy/%.cnf: %.cnf | dummy
	docker cp $< $(CONTAINER):/etc/mysql/$<
	touch $@


# Openssl stuffs

CACERT = certs/ca.crt
CAKEY = certs/ca-key.pem
SERVER_CERT = certs/server.crt
SERVER_KEY = certs/server-key.pem
SSLCONF = openssl.cnf

clean-certificates: | certs
	rm certs/*

# root key
$(CAKEY): | certs
	openssl genrsa 2048 > $@
# self-signed certificate from this key
$(CACERT): $(CAKEY) $(SSLCONF)
	openssl req -new -x509 -days 366 -key $< -out $@ -config $(SSLCONF)
# certificate for second user
certs/pwdLoader.crt: certs/second-issuer.crt certs/pwdLoader-req.pem | certs
	openssl x509 -req -in certs/pwdLoader-req.pem -days 366 -CA $< -CAkey certs/second-issuer-key.pem -set_serial 01 -out $@

certs/%-req.pem: $(SSLCONF)
	openssl req -newkey rsa:2048 -days 366 -keyout certs/$*-key.pem -out certs/$*-req.pem -config $(SSLCONF)
	openssl rsa -in certs/$*-key.pem -out certs/$*-key.pem
certs/%.crt: certs/%-req.pem $(CAKEY) $(CACERT)
	openssl x509 -req -in $< -days 366 -CA $(CACERT) -CAkey $(CAKEY) -set_serial 01 -out $@



# Directory targets

mysql:
	## No mysql availible! Please download a mysql instance and put it into mysql directory ##
	false

dummy:
	mkdir -p dummy
dummy/run: | dummy
	mkdir -p dummy/run
certs:
	mkdir -p certs
