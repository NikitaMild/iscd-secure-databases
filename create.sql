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
