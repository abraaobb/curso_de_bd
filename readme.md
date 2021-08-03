# Curso de Banco de Dados

## Dia 1

Criar docker-compose docker-postgres.yml

```yaml
version: '3.1'

services:
  
  db:
    image: postgres
    ports:
      - 5434:5434
    restart: always
    environment:
      POSTGRES_PASSWORD: admin
    volumes:
      - dbdata:/var/lib/postgresql/data

  pg:
    image: dpage/pgadmin4
    restart: always
    ports:
      - 9090:80
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: 123456

volumes:
  dbdata:
```

Executar docker-compose

```bash
docker-compose -f .\docker-postgres.yml up -d
```

Usar o query tools para criar a base de dados

```sql
-- criar base de dados
create database curso;
```

- DDL
  - Linguagem de definição de dados, estão associados a **CREATE**, **ALTER** E **DROP**, ou seja, está relacionado as estruturas criadas no seu banco de dados.

Tipos primitivos

```sql
integer
varchar(tamanho)
boolean
bigint
smallint
text
numeric(tamanho,decimais)
date
timestamp

generated
```

Sequences são para organizar contadores (incrementador)

```sql
create sequence incrementador start 1 increment 1;
select nextval('incrementador');
-- o tipo serial tambem é um sequence
```

Schemas são parecidas com pastas para organizar o banco. Por padrão vem o public

```sql
create schema cadastros;
```

Por exemplo para criar um tabela dentro do schema cadastro

```sql
create table cadastros.zona(
	id smallint not null,
	nome varchar(20) not null
);
```

para criar usuários

```sql
-- obs: isso não é um comando de ddl
create user abraao with encrypted password '123';
```

OBS: schemas e bd não é a mesma coisa. mas cada banco de dados tem maneiras diferentes de trabalhar.

------

alterar a tabela e inserir uma nova coluna

```sql
-- alterar a tabela cliente e adicionar a coluna salario e validar como não nula (obs: pude colocar como não nulo pq não existe nenhum valor inserido na tabela)
alter table cliente add column salario numeric(10,2) not null;

-- alterar a tabela cliente e adicionar a coluna data_aniversario
alter table cliente add column data_aniversario date not null;
```

alterar um sequence

```sql
-- altera o sequence incrementador. ou seja, ele volta ao valor 1
alter sequence incrementador restart;
```

alterar um usuario

```sql
-- agora o usuario abraao é superuser
alter user abraao superuser;
```

------

Comandos de **DROP**

Para dropar um schema

```sql
-- dropar tabela zona
drop table cadastros.zona;

-- dropar schema cadastros
drop schema cadastros;
```

------

**Primary Key**

Chave primaria é um conjunto de colunas que compõe a unicidade de um registro no banco de dados.

- Não usar CPF como PK
- Em grande parte dos casos criar **surrogates**

```sql
-- dessa forma o nome da primary key é definido pelo postgres
create  table funcionario(
	id integer not null primary key,
	nome varchar(104) not null
);

drop table funcionario

-- dessa forma definimos um nome para a primary key
create table funcionario(
	id serial not null,
	nome varchar(104) not null,
	constraint pk_funcionario primary key (id)
);
```

Atividade:

```sql
-- criar uma tabela, mas a coluna id não está definida como PK
create  table cliente(
	id integer not null,
	nome varchar(104) not null
);

-- ver como está a tabela
select * from cliente;

-- remover a coluna id
alter table cliente drop column id;

-- criar a coluna id do tipo serial
alter table cliente add column id serial not null;

-- definir id como pk
alter table cliente add constraint pk_cliente primary key (id);

-- ver se está tudo ok
select * from cliente;


-- outra forma de resolver o problema
create  table cliente(
	id integer not null,
	nome varchar(104) not null
);

alter table cliente add constraint pk_cliente primary key (id);
```

- Não recomendado criar PK compostas
- Uma tabela so pode ter uma PK
- Mas um tabela pode ter uma PK composta por dois atributos

Atividade: remover chave composta, criar a coluna id serial e definir como pk

```sql
-- criar tabela (sem id) e com chave composta
create table bairro(
	nome varchar(40) not null,
	zona varchar(20) not null,
	constraint pk_bairro primary key (nome, zona)
);

-- inserir valor dentro da tabela bairro
insert into bairro (nome, zona) values ('São José', 'Leste');

-- verificar se foi criado
select * from bairro;

-- apagar a chave composta
alter table bairro drop constraint pk_bairro;

-- adicionar coluna id
alter table bairro add column id serial not null;

-- adicionar o constraint e definir id como PK
alter table bairro add constraint pk_bairro primary key (id);

-- forma reduzida
alter table bairro
drop constraint pk_bairro,
add column id serial not null,
add constraint pk_bairro primary key (id);
```

**OBS:** o tipo serial é apenas para o postgres criar um tipo integer com uma sequencia (sequences)

------

**FOREIGN KEY**

- Chamadas de chave estrangeira
- Determina a relação entre duas tabelas
- Ex: Um funcionário trabalha em um departamento e um departamento pode contar um ou mais funcionários

```sql
drop table funcionario;

create table departamento(
	id serial not null,
	nome varchar(104) not null,
	constraint pk_departamento primary key (id)
);

-- a fk será do tipo integer (usar somente serial quando for fazer increment)
create table funcionario(
	id serial not null,
	nome varchar(104) not null,
	id_departamento integer not null,
	constraint pk_funcionario primary key (id),
	constraint fk_funcionario_departamento foreign key (id_departamento) references departamento (id)
);

insert into departamento (nome) values ('TI');
insert into departamento (nome) values ('Financeiro');

select * from departamento;
select * from funcionario;

insert into funcionario (nome, id_departamento) values ('Abraão','1');
insert into funcionario (nome, id_departamento) values ('Ozzy','1');
insert into funcionario (nome, id_departamento) values ('Tatiane','2');
insert into funcionario (nome, id_departamento) values ('Gisele','4');
```

Valores default

atividade:

1. Criar um sequence
2. restartar o sequence em 3
3. associar o valor do sequence ao id da tabela produto

```sql
create table produto(
	id integer not null,
	nome varchar(104) not null,
	preco_venda numeric(10,2) not null default 10.00,
	ativo boolean not null default true,
	constraint pk_produto primary key (id)
);

insert into produto (id, nome) values (1, 'Coca-cola');
insert into produto (id, nome) values (2, 'Fanta');

select * from produto;

-- fazer um script para criar um sequence
create sequence produto_id_seq start 1 increment 1;

-- restartar o sequence para 3
alter sequence produto_id_seq restart 3;

-- associar o valor do sequence ao id da tabela produto
alter table produto alter column id set default nextval('produto_id_seq');

-- adicionar mais um produto para ver se esta funcionando
insert into produto (nome, preco_venda) values ('Pepsi', 15.5);

-- ver se esta funcionando
select * from produto;
```

Exercício

- Criar um schema vendas onde nossa tabela deverá ser criada;
- Criar uma tabela de fornecedor com NOME, CNPJ, não é para criar chave primárias nesse momento;
- Adicionar uma coluna para identificar se o registro está ou não ativo, o valor default deve ser verdadeiro;
- Adicionar uma coluna para data de cadastro, o valor default deve ser a data atual;
- Criar um sequence para controlar o incremento do ID da tabela fornecedor;
- Criar uma coluna ID e definir ela como chave primária da tabela de fornecedor e setar o valor default com o sequence.

```sql
	drop schema vendas;

	drop table vendas.fornecedor;

	drop sequence vendas.fornecedor_id_seq;

	create schema vendas;

	create table vendas.fornecedor (
		nome varchar(104) not null,
		cnpj varchar(11) not null
	);

	select * from vendas.fornecedor;

	alter table vendas.fornecedor add column is_ativo bool not null default true;

	alter table vendas.fornecedor add column data_cadastro timestamp not null default now();

	alter table vendas.fornecedor add column id integer not null;

	create sequence vendas.fornecedor_id_seq start 1 increment 1;

	alter table vendas.fornecedor alter column id set default nextval('vendas.fornecedor_id_seq');

	alter table vendas.fornecedor add constraint pk_fornecedor primary key (id);

	insert into vendas.fornecedor(nome, cnpj) values ('Abraao', '12345678912')

```

Check

```sql
select * from funcionario;

-- não posso deixar como not null pq ja existem valores inseridos;
alter table funcionario add column sexo varchar(1)

alter table funcionario add constraint check_funcionario_sexo check (sexo in ('M', 'F'));

-- vai dar erro pq o check A não é permitido
insert into funcionario (nome, id_departamento, sexo) values ('Artur', 1, 'A');

insert into funcionario (nome, id_departamento, sexo) values ('Artur', 1, 'M');

select * from funcionario;
```

CHECK

Exercício

* Criar uma coluna para o preço de custo do produto;
* Criar uma regra para que o campo preço de custo seja maior que 0;
* Criar uma regra para que o campo preço de venda seja maior que 0;
* Criar uma regra para que o preço de venda seja maior que o preço de custo;

```sql
select * from produto;

alter table produto add column preco_custo numeric (10,2);

alter table produto add constraint check_preco_venda check (preco_venda > 0);

alter table produto add constraint check_preco_custo check (preco_custo > 0);

alter table produto add constraint check_produto_preco_venda_maior_custo check (preco_venda > preco_custo);

-- testes
insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', -1, 1000);

insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', 900, 1000);

insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', 1100, 1000);
```

REVISÃO

```sql
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
```

Exercício de modelagem:

​		Um pequeno país resolveu informatizar sua única delegacia de polícia para criar um banco de dados onde os criminosos deverão ser fichados, sendo que as suas vítimas também deverão ser cadastradas.
​		No caso de criminosos que utilizem armas, estas deverão ser cadastradas e relacionadas ao crime cometido para possível utilização no julgamento do criminoso.
​		O sistema, além de fornecer dados pessoais dos criminosos, das vítimas e das armas, também deve possibilitar saber:

* Quais crimes um determinado criminoso cometeu, lembrando que um crime
  pode ser cometido por mais de um criminoso;

- Quais crimes uma determinada vítima sofreu, lembrando que várias vítimas
  podem ter sofrido um mesmo crime;

Após o sistema ser colocado em funcionamento, serão definidos relatórios e estatísticas de acordo com a solicitação do chefe da delegacia.

------

## Dia 2

Começar resolvendo exercício anterior

