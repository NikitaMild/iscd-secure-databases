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

dummy/docker: Dockerfile docker-compose.yml mysql | dummy
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


# Directory targets

mysql:
	## No mysql availible! Please download a mysql instance and put it into mysql directory ##
	false

dummy:
	mkdir -p dummy
dummy/run: | dummy
	mkdir -p dummy/run
