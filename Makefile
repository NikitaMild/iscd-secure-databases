CONTAINER = iscdsecuredatabases_ubuntu-mysql_1

.PHONY: run
run: dummy/docker dummy/supervisor.sh dummy/starters
	docker-compose up

.PHONY: build
build: dummy/docker

dummy/starters: dummy/run/start_instance.sh
	touch dummy/starters

dummy/docker: Dockerfile docker-compose.yml mysql | dummy
	docker-compose build
	touch dummy/docker
	touch dummy/supervisor.sh
	touch dummy/run/*

dummy/supervisor.sh: supervisor.sh | dummy
	docker cp $< $(CONTAINER):/usr/local/bin/$<
	touch $@

dummy/run/%.sh: run/%.sh | dummy/run
	docker cp $< $(CONTAINER):/opt/$<
	touch $@


# Directory targets

mysql:
	## No mysql availible! Please download a mysql instance and put it into mysql directory ##
	false

dummy:
	mkdir -p dummy
dummy/run: | dummy
	mkdir -p dummy/run
