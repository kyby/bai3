-- delete db
use bai3;
drop table users;
drop table unregistered_users;
drop table allowed_messages;
drop table messages;
drop database bai3;


-- create db
create database bai3;
use bai3;

create table users (
	user_id int not null primary key auto_increment,
	username varchar(30) not null,
	password_hash varchar(16) not null,
	salt varchar(8) not null,
	last_login timestamp default 0,
	last_bad_login timestamp default 0,
	login_attempts int default 0,
	unlock_login_time timestamp default 0,
	is_blocked boolean default 0,
	block_after int default 0,
	login_attempts_block int default 0,
	ret_question varchar(50),
	ret_answer varchar(50)
);

create table passwords (
	password_id int not null primary key auto_increment,
	user_id int not null,
	password_hash varchar(24) not null,
	number_of_chars int not null,
	mask varchar(24) not null,
	is_used int not null default 0
);

create table unregistered_users (
	user_id int not null primary key auto_increment,
	username varchar(30) not null,
	last_bad_login timestamp default 0,
	login_attempts int default 0,
	unlock_login_time timestamp default 0,
	is_blocked boolean default 0,
	block_after int default 7,
	login_attempts_block int default 0,
	ret_question varchar(50),
	ret_answer varchar(50)
);

create table messages (
	message_id int not null primary key auto_increment,
	text varchar(100) not null,
	owner int not null,
	modified timestamp not null default current_timestamp on update current_timestamp,
	foreign key (owner) references users(user_id)
);

create table allowed_messages (
	user_id int not null,
	message_id int not null,
	foreign key (user_id) references users(user_id),
	foreign key (message_id) references messages(message_id)
);

-- trigger
delimiter $$
create trigger hash_passwords_insert
before insert on users
for each row
begin
	declare s varchar(10);
	set s = concat(char(round(rand()*25)+97), round(rand()*25)+97, char(round(rand()*25)+97), round(rand()*25)+97, char(round(rand()*25)+97), char(round(rand()*25)+97), char(round(rand()*25)+97), round(rand()*25)+97),
	new.password_hash = md5(concat(new.password_hash, s)),
	new.salt = s;
	
	
	-- generowanie maski
		-- jaka jest długość hasła? ogólnie można zapytać o N = <5, 8> znaków
			-- jeśli długość jest większa niż 8, to maxN = (int) długość / 2
			-- jeśli długość jest mniejsza niż 8, to maxN = 5
			-- minN = 5
		-- generowanie maski o długości max długości hasła, czyli 24,
			-- gdzie 1 oznacza wylosowane znaki, a 0 niewylosowane znaki
	-- generowanie password_hash
		-- dla każdej maski generujemy hash hasła
	
	--insert into passwords (user_id, password_hash, mask, is_used) values
	--(new.user_id, );
end$$

create trigger hash_passwords_update
before update on users
for each row
begin
	declare s varchar(10);
	set s = concat(char(round(rand()*25)+97), round(rand()*25)+97, char(round(rand()*25)+97), round(rand()*25)+97,
	char(round(rand()*25)+97), char(round(rand()*25)+97), char(round(rand()*25)+97), round(rand()*25)+97),
	new.password_hash = md5(concat(new.password_hash, s)),
	new.salt = s;
end$$
delimiter ;

-- populate db
insert into users (username, password_hash, block_after, ret_question, ret_answer) values
	('user1', 'zaq12wsx', 8, 'Ulubiony film?', 'Interstellar');
insert into users (username, password_hash, block_after, ret_question, ret_answer) values
	('user2', 'pl,0okm9ijn8uhb7', 3, 'Ulubiony kolor?', 'Niebieski');
insert into users (username, password_hash) values
	('user3', 'b7;/9mhcuei394');	

insert into messages (text, owner) values
	('wiadomosc 1', 1);
insert into messages (text, owner) values
	('wiadomosc 2', 1);
insert into messages (text, owner) values
	('wiadomosc 3', 1);
insert into messages (text, owner) values
	('wiadomosc 4', 2);


insert into allowed_messages (user_id, message_id) values
	(1, 1);
insert into allowed_messages (user_id, message_id) values
	(1, 2);
insert into allowed_messages (user_id, message_id) values
	(1, 3);
insert into allowed_messages (user_id, message_id) values
	(2, 4);

