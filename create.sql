create schema if not exists firewall_logs;
create schema if not exists password_hashes;


-- Users and permissions --

create user if not exists 'admin'@'%'
	identified by 'changeme'
;
grant alter, create, delete, drop, insert, select, update
	on *.*
	to 'admin'@'%'
;


create user if not exists 'firewallAdmin'@'localhost'
	identified by 'changeme'
;
grant all privileges
	on firewall_logs.*
	to 'firewallAdmin'@'localhost'
	with grant option
;

create user if not exists 'pwdLoader'@'%'
	identified by 'changeme'
;
grant insert
	on password_hashes.*
	to 'pwdLoader'@'%'
;

create user if not exists 'pwdAnalyst'@'localhost'
	identified by 'changeme'
;
grant select
	on password_hashes.*
	to 'pwdAnalyst'@'localhost'
	with grant option
;

create user if not exists ''@'%'
;
revoke all privileges
	on *.*
	from ''@'%'
;


-- Tables --

-- firewall will be my pok et mon
use firewall_logs;
create table if not exists stream_logs
	( id           INTEGER AUTO_INCREMENT
	, service_name VARCHAR(64)
	, start_time   DATETIME
	, source_addr  VARCHAR(15)
	, source_port  SMALLINT
	, dest_addr    VARCHAR(15)
	, dest_port    SMALLINT
	, stream_data  BLOB
	, PRIMARY KEY (id)
	)
;

-- passwords
use password_hashes;
create table if not exists yandex
	(email         VARCHAR(256)
	,password_hash VARCHAR(256) CHARACTER SET binary
	)
;
create table if not exists google
	(email         VARCHAR(256)
	,password_hash VARCHAR(256)
	)
;
create table if not exists mail_ru
	(email         VARCHAR(256)
	,password_hash VARCHAR(256)
	)
;
