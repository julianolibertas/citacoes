show databases;

show tables;
-- tabela clientes
create table comclien(
	n_numeclien int NOT NULL auto_increment,
	c_codiclien varchar(10) UNIQUE,
	c_nomeclien varchar(100) NOT NULL,
	c_razaclien varchar(100),
	d_dataclien date default (CURRENT_DATE),
	c_cnpjclien varchar(18),
	c_foneclien varchar(15),
	c_cidaclien varchar(100),
	c_estaclien varchar(50),
	primary key (n_numeclien)
);

desc comclien;
-- tabela fornecedores
create table comforne (
	n_numeforne int PRIMARY key not null auto_increment,
	c_codiforne varchar(10) UNIQUE,
	c_nomeforne varchar(100) not null,
	c_razaforne varchar(100) not null,
	c_foneforne varchar(15)
);

desc comforne;
-- tabela vendedores
create table comvende (
	n_numevende int PRIMARY KEY NOT NULL auto_increment,
	c_codivende varchar(10) UNIQUE,
	c_nomevende varchar(100) NOT NULL,
	c_razavende varchar(100),
	c_fonevende varchar(15),
	n_porcvende decimal(5,2) NOT NULL default 0.00,
	CONSTRAINT chk_porcvende CHECK (n_porcvende >= 0.00 
		AND n_porcvende <= 100.00)
);

-- tabela produtos
create table comprodu (
	n_numeprodu int primary key not NULL auto_increment,
	c_codiprodu varchar(10) UNIQUE,
	c_descprodu varchar(100) NOT NULL,
	n_valoprodu decimal(10,2) NOT NULL default 0.00,
	c_situprodu varchar(1) NOT NULL DEFAULT 'A',
	n_numeforne int not null,
	CONSTRAINT chk_valor CHECK (n_valoprodu >= 0.00),
	constraint chk_situacao 
		CHECK (c_situprodu in ('A', 'I')),
	constraint fk_comprodu_comforme 
		FOREIGN KEY (n_numeforne)
		REFERENCES comforne (n_numeforne)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

desc comprodu;

-- tabela Vendas
create table comvenda (
	n_numevenda int primary key not null auto_increment,
	c_codivenda varchar(10) UNIQUE,
	n_numeclien int NOT null,
	n_numeforne int NOT null,
	n_numevende int NOT null,
	n_valovenda decimal(10,2) not null default 0.00,
	n_descvenda decimal(10,2) not null default 0.00,
	n_totavenda decimal(15,2) not null default 0.00,
	d_datavenda date not null default (current_date),
	constraint chk_valores CHECK (
		n_valovenda >= 0.00
		and n_descvenda >= 0.00
		and n_totavenda >= 0.00),
	constraint fk_comvenda_comclien 
		FOREIGN KEY (n_numeclien)
		REFERENCES comclien (n_numeclien)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	constraint fk_comvenda_comforne 
		FOREIGN KEY (n_numeforne)
		REFERENCES comforne (n_numeforne)
		ON DELETE RESTRICT
		ON UPDATE CASCADE,
	constraint fk_comvenda_comvende 
		FOREIGN KEY (n_numevende)
		REFERENCES comvende (n_numevende)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
);

-- tabela de itens da venda
CREATE TABLE comivenda (
	n_numeivenda int PRIMARY KEY not null auto_increment,
	n_numevenda int NOT NULL,
	n_numeprodu int NOT NULL,
	n_valoivenda decimal(10,2) not null DEFAULT 0.00,
	n_qtdeivenda int not null default 1,
	n_descivenda decimal(10,2) not null default 0.00,
	CONSTRAINT chk_qtde CHECK (n_qtdeivenda > 0),
	CONSTRAINT chk_valores 
		CHECK (n_valoivenda >= 0.00 and n_descivenda >=0)
);

desc comclien;
desc comforne;
desc comvende;
desc comvenda;
desc comivenda;

-- adiciona um campo novo c_estclien na tabela comclien;
alter table comclien add column c_estclien varchar(50);

-- excluindo um campo da tabela comclien
alter table comclien drop column c_estclien;
-- altera o tipo do campo
alter table comclien modify column c_estaclien int;
alter table comclien modify column c_estaclien varchar(100);

desc comclien;

insert into comclien (
		n_numeclien, 
		c_codiclien, 
		c_nomeclien,
		c_razaclien,
		d_dataclien,
		c_cnpjclien,
		c_foneclien,
		c_cidaclien,
		c_estaclien
) values (
		1,
		'0001',
		'AARONSON',
		'AARONSON FURNITURE LTDA',
		'2015-02-17',
		'17.807.928/0001-85',
		'(21) 8167-6584',
		'QUEIMADOS',
		'RJ'
);


SET AUTOCOMMIT = 0;

UPDATE comclien set c_nomeclien = 'AARONSON FURNITURE',
					c_cidaclien = 'LONDRINA',
					c_estaclien = 'PR'
					where n_numeclien = 1;
COMMIT;

select * from comclien;

UPDATE comclien set c_nomeclien = 'AARONSON'
					where n_numeclien = 1;
ROLLBACK;
				
DELETE FROM comclien;

SET AUTOCOMMIT = 1;

DELETE FROM comclien where n_numeclien = 1;

truncate table comivenda;

alter table comclien modify column d_dataclien datetime;

select * from comclien;
select n_numeclien, c_codiclien, c_razaclien from comclien;
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where c_codiclien='0001';
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where c_codiclien<>'0001';
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where c_razaclien like 'L%';
select distinct n_numeclien from comvenda;
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where n_numeclien in (1,3,5);
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where n_numeclien not in (1,3,5);
select n_numeclien, c_codiclien, c_razaclien from comclien 
				where n_numeclien not in 
				(select n_numeclien from comvenda );

select * from comvenda;

select v.c_codivenda Cod_venda, 
	(select c_razaclien from comclien c 
	where c.n_numeclien = v.n_numeclien) 
from comvenda v;

select v.c_codivenda, c.c_razaclien 
from comvenda v, comclien c
where v.n_numeclien = c.n_numeclien
and v.n_numevenda in (1,2,3,4,5);

create table comclien_bkp_sp as 
(select * from comclien c where c.c_estaclien='SP');

select * from comclien_bkp_sp;

create table comcontato(
	n_numecontato int primary key NOT NULL 
		auto_increment,
	c_nomecontato varchar(200) not null,
	c_fonecontato varchar(30),
	c_cidacontato varchar(200),
	c_estacontato varchar(2),
	n_numeclien int not NULL 
);

insert into comcontato(
	select n_numeclien,
		c_nomeclien,
		c_foneclien,
		c_cidaclien,
		c_estaclien,
		n_numeclien
		from comclien
);

select * from comcontato;

delete from comcontato 
	where n_numeclien not in
	(select n_numeclien from comvenda);

-- FUNÇÕES

-- Lista todas as vendas e quem comprou
select v.c_codivenda, c.c_razaclien   
	from comvenda v, comclien c
	where v.n_numeclien = c.n_numeclien 
	order by c.c_razaclien;
-- Lista apenas quem comprou
select c.c_codiclien , c.c_razaclien   
	from comclien c, comvenda v
	where c.n_numeclien = v.n_numeclien
	group by c.c_codiclien , c.c_razaclien 
	order by c.c_razaclien;
-- Lista quem comprou e quantas vezes
select c.c_codiclien , c.c_razaclien, 
	count(v.n_numevenda) Qtde   
	from comclien c, comvenda v
	where c.n_numeclien = v.n_numeclien
	group by c.c_codiclien , c.c_razaclien
	order by c.c_razaclien;
-- Having, os clientes que tiveram mais de 2 vendas
select c.c_codiclien , c.c_razaclien, 
	count(v.n_numevenda) Qtde   
	from comclien c, comvenda v
	where c.n_numeclien = v.n_numeclien
	group by c.c_codiclien , c.c_razaclien
	having count(v.n_numevenda) > 2 ;
-- maior venda
select max(v.n_totavenda) maior_venda from comvenda v;
-- menor venda
select min(v.n_totavenda) menor_venda from comvenda v;
-- menor e maior venda
select min(v.n_totavenda) menor_venda,
max(v.n_totavenda) maior_venda
from comvenda v;




















