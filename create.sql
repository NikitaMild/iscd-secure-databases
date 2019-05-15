create schema if not exists firewall_logs;
create schema if not exists password_hashes;


-- Users and permissions --

drop user if exists 'admin'@'%';
create user if not exists 'admin'@'%'
	identified by 'changeme'
	require SUBJECT '/C=RU/ST=Tomskaya obl./L=Tomsk/O=Tomsk State University/O=ISCD/OU=ISCD Secure Databases/CN=morj/emailAddress=morj@example.com'
;
grant alter, create, delete, drop, insert, select, update
	on *.*
	to 'admin'@'%'
;


create user if not exists 'firewallAdmin'@'%'
	identified by 'changeme'
	require SSL
;
grant all privileges
	on firewall_logs.*
	to 'firewallAdmin'@'%'
	with grant option
;

create user if not exists 'pwdLoader'@'%'
	identified by 'changeme'
	require ISSUER '/C=RU/ST=Tomskaya obl./L=Tomsk/O=TUSUR/CN=fryngies/emailAddress=fryngies@example.com'
;
grant insert
	on password_hashes.*
	to 'pwdLoader'@'%'
;

create user if not exists 'pwdAnalyst'@'%'
	identified by 'changeme'
	require X509
;
grant select
	on password_hashes.*
	to 'pwdAnalyst'@'%'
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
