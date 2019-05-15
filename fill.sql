create schema if not exists firewall_logs;
create schema if not exists password_hashes;

create user if not exists 'admin'@'%'
	identified by 'changeme'
;

create user if not exists 'firewallAdmin'@'localhost'
	identified by 'changeme'
;

create user if not exists 'pwdLoader'@'%'
	identified by 'changeme'
;

create user if not exists 'pwdAnalyst'@'localhost'
	identified by 'changeme'
;

create user if not exists ''@''
;
revoke all privileges
	on *.*
	from ''@''
