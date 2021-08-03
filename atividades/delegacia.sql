create database delegacia;

create table pessoa(
	id serial not null,
	nome varchar(104) not null,
	cpf varchar(11) not null,
	telefone varchar(11) not null,
	data_nasc date not null,
	endereco varchar(256) not null,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_pessoa primary key(id),
	constraint ak_pessoa_cpf unique (cpf)
);

create table tipo_crime (
	id serial not null,
	nome varchar(104) not null,
	tempo_min_prisao smallint,
	tempo_max_prisao smallint,
	tempo_prescricao smallint,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_tipo_crime primary key(id),
	constraint ak_tipo_crime_nome unique (nome)
);

create table arma (
	id serial not null,
	numero_serie varchar(104),
	descricao varchar(256) not null,
	tipo varchar (1) not null,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_arma primary key(id)
);

create table crime (
	id serial not null,
	id_tipo_crime integer not null,
	data timestamp not null,
	local varchar(256) not null,
	observacao text,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime primary key(id),
	constraint fk_crime_tipo_crime foreign key (id_tipo_crime) references tipo_crime(id)
);

create table crime_arma(
	id serial not null,
	id_arma integer not null,
	id_crime integer not null,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime_arma primary key(id),
	constraint ak_crime_arma unique (id_arma, id_crime),
	constraint fk_crime_arma_arma foreign key (id_arma) references arma(id),
	constraint tk_crime_arma_crime foreign key (id_crime) references crime(id)
);

create table crime_pessoa(
	id serial not null,
	id_pessoa integer not null,
	id_crime integer not null,
	tipo varchar(1) not null,
	is_ativo boolean not null default true,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	constraint pk_crime_pessoa primary key(id),
	constraint ak_pessoa_crime unique (id_pessoa, id_crime),
	constraint fk_crime_pessoa_pessoa foreign key (id_pessoa) references pessoa(id),
	constraint tk_crime_pesoa_crime foreign key (id_crime) references crime(id)
);