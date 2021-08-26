-- revisão

-- criar a tabela
create table pessoa(
	nome varchar(104) not null
);

-- adicionar coluna id
alter table pessoa add column id integer not null;

-- ver tabela
select * from pessoa;

-- criar uma pk e apontar para o id
alter table pessoa add constraint pk_pessoa primary key (id);

-- criar um sequence para o id
create sequence pessoa_id_seq;

-- setar como default o sequence para o id
alter table pessoa alter column id set default nextval('pessoa_id_seq');

-- testar
insert into pessoa (nome) values ('Abraão');
insert into pessoa (nome) values ('Brito');
insert into pessoa (nome) values ('Brandão');