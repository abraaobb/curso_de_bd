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

Começar resolvendo a modelagem

INDEX

- Temos um índice específico para controle de unicidade UNIQUE INDEX
- também temos índices relacionados a performance e devem ser usados de acordo com seus cenários.

```sql
-- seleciona o departamento
select * from departamento;

-- cria uma chave unica
create unique index ak_departamento_nome on departamento (upper(nome));

--inserir um valor repetido para testar
insert into departamento (nome) values ('TI');

-- outra forma de fazer
-- excluir a chave unica
drop index ak_departamento_nome

-- alterar a tabela e adicionar o constrain
alter table departamento
add constraint ak_departamento_nome unique (nome);

-- para dropar
alter table departamento
drop constraint ak_departamento_nome
```

exercicio

* Na tabela de bairro criada anteriormente, onde nós definimos uma chave composta, faça as seguintes questões.
  1. Apagar a chave primaria composta;
  2. criar uma chave primaria simples com serial
  3. criar um índice único composto por nome do bairro e nome da zona
  4. criar um índice hash para o nome da zona

```sql
select * from bairro

alter table bairro
drop column id

alter table bairro
add column id serial not null

alter table bairro
add constraint pk_bairro primary key (id)

alter table bairro
add constraint ak_bairro unique (nome, zona)

create index idx_bairro_zona on bairro using hash (zona)
```

DCL

* É a linguagem que define a parte de controle de estrutura e dados, geralmente relacionada aos comandos GRANT E REVOKE.
* Vamos criar um usuário sem acesso de super usuário e logo em seguida criar uma nova conexão para esse usuário.

Criar novo usuário

```sql
create user abraao with encrypted password '123';
create user giih superuser encrypted password '123';
```

Dar permissões

```sql
-- como super usuiario
grant select on bairro to abraao;

grant insert on bairro to abraao;

grant update on bairro_id_seq to abraao;

grant delete on bairro to abraao;

-- remover as permissões
revoke all on bairro from abraao;
```

permissão parcial a um usuario

```sql
grant select (nome) on bairro to abraao
```

criar grupos

```sql
-- criar o grupo
create role colaboradores;

-- adicionar usuarios
alter group colaboradores add user abraao;
alter group colaboradores add user alice;

-- dar a permissao ao grupo
grant select on bairro to colaboradores;

-- criar usuario
create user alice encrypted password '123';
```

Exercicio
Tendo em vista que a consulta abaixo retorna as tabelas nos bancos da sua instância do PostgreSQL e que o exemplo em seguida faz concatenações de string, crie uma consulta para dar permissão de leitura para todas as tabelas para um determinado usuário.

```sql
select * from pg_tables;
```

```sql
select * from pg_tables where schemaname in ('public', 'vendas');

select schemaname, tablename from pg_tables;

select 
	concat('grant select on ', schemaname, '.', tablename, 'to abraao;')
from pg_tables
where schemaname in ('public', 'vendas')


grant select on public.departamentoto abraao;
grant select on public.produtoto abraao;
grant select on public.pessoato abraao;
grant select on public.clienteto abraao;
grant select on vendas.fornecedorto abraao;
grant select on public.funcionarioto abraao;
grant select on public.bairroto abraao;
```

outra forma

```sql
do
$$
declare
	consulta record;
	comando varchar default '';
begin
	for consulta in select * from pg_tables where schemaname in ('public', 'vendas') loop
		comando := concat('grant select on ', consulta.schemaname, '.', consulta.tablename, ' to abraao;');
		-- raise notice 'table: %', comando;
		execute comando;
	end loop;
end;
$$
```

```sql
do
$$
declare
	consulta record;
	comando varchar default '';
begin
	for consulta in select * from pg_tables where schemaname in ('public', 'vendas') loop
		comando := concat('grant select on ', consulta.schemaname, '.', consulta.tablename, ' to abraao;');
		-- raise notice 'table: %', comando;
		execute comando;
	end loop;
end;
$$
```

Para criar um ponto onde possa desfazer as alterações usar o beggin

```sql
select * from departamento;

insert into departamento (nome) values ('Diretoria');

begin;
	insert into departamento (nome) values ('Diretoria 01');
	insert into departamento (nome) values ('Diretoria 02');
	insert into departamento (nome) values ('Diretoria 03');
	insert into departamento (nome) values ('Diretoria 04');
	insert into departamento (nome) values ('Diretoria 05');
commit;

rollback;
```

Exercício

* Criar uma coluna salário na tabela funcionário com valor default 0.00 obrigatória;
* Fazer um update para atualizar o salário para o id * 1000;
* Criar um bloco anônimo para gerar um loop de 1000 iterações e cadastrar vários funcionários
    * O nome do funcionário deve ser no formato FUNCIONARIO_{CONTADOR};
    * O departamento deve ser sempre o de TI;
    * o sexo vai depender do valor do contador se for ímpar Masculino, senão feminino;
    * Salário deve ser gerado de forma randômica;
    * Criar um usuário orelha que tem permissão de fazer SELECT na tabela de funcionário porém ele não pode em hipótese alguma visualizar o salário;

Exemplo de bloco anonimo

```sql
do
$$
declare
	idade integer default 18;
begin
	if idade >=18 then
		raise notice 'Maior de idade';
	else
		raise notice 'Menor de idade';
	end if;
end;
$$

-- exemplo 2 para while
do
$$
declare
	contador integer default 1;
begin
	while contador <= 1000 loop
		raise notice 'contador: %', contador;
		contador := contador + 1;
	end loop;
end;
$$
```

Resultado

```sql
-- ver os funcionarios
select * from funcionario;
-- ver os departamentos
select * from departamento;
-- adicionar a coluna salario
alter table funcionario add column salario numeric(10,2) not null default 0.00;
-- fazer updade no salario
update funcionario set salario = id*1000;
-- teste de random
select round(random() *1000);
-- exercicio
do
$$
declare
	contador integer;
	sexo varchar(1);
begin
	for contador in 1..1000 loop
		if mod(contador, 2) = 1 then
			sexo = 'M';
		else
			sexo = 'F';
		end if;
		insert into funcionario(nome, salario, sexo, id_departamento) 
		values (
			'FUNCIONARIO_' || contador::varchar,
			round(random() * 1000),
			sexo,
			1
		);
	end loop;
end;
$$
```

## Dia 3

pg_table

para iniciar o processo

```sql
-- criar nova base de dados
CREATE DATABASE sale;

-- para buscar os nomes das tabelas e dropar
select 'drop table ' || tablename || ';'
from pg_tables
where schemaname = 'public';
```

criar o banco

```sql
/*================================================================================*/
/* DDL SCRIPT                                                                     */
/*================================================================================*/
/*  Title    :                                                                    */
/*  FileName : sale.ecm                                                           */
/*  Platform : PostgreSQL 9.4                                                     */
/*  Version  : Concept                                                            */
/*  Date     : quarta-feira, 21 de julho de 2021                                  */
/*================================================================================*/
/*================================================================================*/
/* CREATE SEQUENCES                                                               */
/*================================================================================*/

CREATE SEQUENCE public.branch_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.city_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.customer_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.department_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.district_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.employee_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.marital_status_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.product_group_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.product_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.sale_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.sale_item_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.state_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.supplier_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

CREATE SEQUENCE public.zone_id_seq START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647;

/*================================================================================*/
/* CREATE TABLES                                                                  */
/*================================================================================*/

CREATE TABLE public.state (
  id INTEGER DEFAULT nextval('state_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  abbreviation CHAR(2) NOT NULL,
  CONSTRAINT PK_state PRIMARY KEY (id)
);

CREATE TABLE public.city (
  id INTEGER DEFAULT nextval('city_id_seq'::regclass) NOT NULL,
  id_state INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_city PRIMARY KEY (id)
);

CREATE TABLE public.zone (
  id INTEGER DEFAULT nextval('zone_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_zone PRIMARY KEY (id)
);

CREATE TABLE public.district (
  id INTEGER DEFAULT nextval('district_id_seq'::regclass) NOT NULL,
  id_city INTEGER NOT NULL,
  id_zone INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_district PRIMARY KEY (id)
);

CREATE TABLE public.branch (
  id INTEGER DEFAULT nextval('branch_id_seq'::regclass) NOT NULL,
  id_district INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_branch PRIMARY KEY (id)
);

CREATE TABLE public.marital_status (
  id INTEGER DEFAULT nextval('marital_status_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_marital_status PRIMARY KEY (id)
);

CREATE TABLE public.customer (
  id INTEGER DEFAULT nextval('customer_id_seq'::regclass) NOT NULL,
  id_district INTEGER NOT NULL,
  id_marital_status INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  income NUMERIC(16,2) NOT NULL,
  gender CHAR(1) NOT NULL,
  CONSTRAINT PK_customer PRIMARY KEY (id)
);

CREATE TABLE public.department (
  id INTEGER DEFAULT nextval('department_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  CONSTRAINT PK_department PRIMARY KEY (id)
);

CREATE TABLE public.employee (
  id INTEGER DEFAULT nextval('employee_id_seq'::regclass) NOT NULL,
  id_department INTEGER NOT NULL,
  id_district INTEGER NOT NULL,
  id_marital_status INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  salary NUMERIC(16,2) NOT NULL,
  admission_date DATE NOT NULL,
  birth_date DATE NOT NULL,
  gender CHAR(1) NOT NULL,
  CONSTRAINT PK_employee PRIMARY KEY (id)
);

CREATE TABLE public.supplier (
  id INTEGER DEFAULT nextval('supplier_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  legal_document VARCHAR(20) NOT NULL,
  CONSTRAINT PK_supplier PRIMARY KEY (id)
);

CREATE TABLE public.product_group (
  id INTEGER DEFAULT nextval('product_group_id_seq'::regclass) NOT NULL,
  name VARCHAR(64) NOT NULL,
  commission_percentage NUMERIC(5,2) NOT NULL,
  gain_percentage NUMERIC(5,2) NOT NULL,
  CONSTRAINT PK_product_group PRIMARY KEY (id)
);

CREATE TABLE public.product (
  id INTEGER DEFAULT nextval('product_id_seq'::regclass) NOT NULL,
  id_product_group INTEGER NOT NULL,
  id_supplier INTEGER NOT NULL,
  name VARCHAR(64) NOT NULL,
  cost_price NUMERIC(16,2) NOT NULL,
  sale_price NUMERIC(16,2) NOT NULL,
  CONSTRAINT PK_product PRIMARY KEY (id)
);

CREATE TABLE public.sale (
  id INTEGER DEFAULT nextval('sale_id_seq'::regclass) NOT NULL,
  id_customer INTEGER NOT NULL,
  id_branch INTEGER NOT NULL,
  id_employee INTEGER NOT NULL,
  date TIMESTAMP(6) NOT NULL,
  CONSTRAINT PK_sale PRIMARY KEY (id)
);

CREATE TABLE public.sale_item (
  id INTEGER DEFAULT nextval('sale_item_id_seq'::regclass) NOT NULL,
  id_sale INTEGER NOT NULL,
  id_product INTEGER NOT NULL,
  quantity NUMERIC(16,3) NOT NULL,
  CONSTRAINT PK_sale_item PRIMARY KEY (id)
);

/*================================================================================*/
/* CREATE INDEXES                                                                 */
/*================================================================================*/

CREATE UNIQUE INDEX AK_state_name ON public.state (name);

CREATE UNIQUE INDEX AK_state_city_name ON public.city (id_state, name);

CREATE UNIQUE INDEX AK_zone_name ON public.zone (name);

CREATE UNIQUE INDEX AK_city_district_name ON public.district (id_city, name);

CREATE UNIQUE INDEX AK_marital_status_name ON public.marital_status (name);

CREATE UNIQUE INDEX AK_department_name ON public.department (name);

CREATE UNIQUE INDEX AK_product_group_name ON public.product_group (name);

CREATE UNIQUE INDEX AK_product_name ON public.product (name);

/*================================================================================*/
/* CREATE FOREIGN KEYS                                                            */
/*================================================================================*/

ALTER TABLE public.city
  ADD CONSTRAINT fk_city_state
  FOREIGN KEY (id_state) REFERENCES public.state (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.district
  ADD CONSTRAINT fk_district_city
  FOREIGN KEY (id_city) REFERENCES public.city (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.district
  ADD CONSTRAINT fk_district_zone
  FOREIGN KEY (id_zone) REFERENCES public.zone (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.branch
  ADD CONSTRAINT fk_branch_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.customer
  ADD CONSTRAINT fk_customer_marital_status
  FOREIGN KEY (id_marital_status) REFERENCES public.marital_status (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.customer
  ADD CONSTRAINT fk_customer_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_department
  FOREIGN KEY (id_department) REFERENCES public.department (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_district
  FOREIGN KEY (id_district) REFERENCES public.district (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.employee
  ADD CONSTRAINT fk_employee_marital_status
  FOREIGN KEY (id_marital_status) REFERENCES public.marital_status (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.product
  ADD CONSTRAINT fk_product_supplier
  FOREIGN KEY (id_supplier) REFERENCES public.supplier (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.product
  ADD CONSTRAINT fk_product_product_group
  FOREIGN KEY (id_product_group) REFERENCES public.product_group (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_branch
  FOREIGN KEY (id_branch) REFERENCES public.branch (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_customer
  FOREIGN KEY (id_customer) REFERENCES public.customer (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale
  ADD CONSTRAINT fk_sale_employee
  FOREIGN KEY (id_employee) REFERENCES public.employee (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale_item
  ADD CONSTRAINT fk_sale_item_product
  FOREIGN KEY (id_product) REFERENCES public.product (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;

ALTER TABLE public.sale_item
  ADD CONSTRAINT fk_sale_item_sale
  FOREIGN KEY (id_sale) REFERENCES public.sale (id)
  ON UPDATE NO ACTION
  ON DELETE NO ACTION;
```

modificar

```sql
select
    'alter table ' || pt.tablename || ' add column created_at timestamp not null default now();',
    'alter table ' || pt.tablename || ' add column modified_at timestamp not null default now();',
    'alter table ' || pt.tablename || ' add column active boolean not null default true;'
from pg_tables pt
where pt.schemaname = 'public';

alter table zone add column created_at timestamp not null default now();
alter table supplier add column created_at timestamp not null default now();
alter table state add column created_at timestamp not null default now();
alter table sale_item add column created_at timestamp not null default now();
alter table sale add column created_at timestamp not null default now();
alter table product_group add column created_at timestamp not null default now();
alter table product add column created_at timestamp not null default now();
alter table marital_status add column created_at timestamp not null default now();
alter table employee add column created_at timestamp not null default now();
alter table district add column created_at timestamp not null default now();
alter table department add column created_at timestamp not null default now();
alter table customer add column created_at timestamp not null default now();
alter table city add column created_at timestamp not null default now();
alter table branch add column created_at timestamp not null default now();

alter table zone add column modified_at timestamp not null default now();
alter table supplier add column modified_at timestamp not null default now();
alter table state add column modified_at timestamp not null default now();
alter table sale_item add column modified_at timestamp not null default now();
alter table sale add column modified_at timestamp not null default now();
alter table product_group add column modified_at timestamp not null default now();
alter table product add column modified_at timestamp not null default now();
alter table marital_status add column modified_at timestamp not null default now();
alter table employee add column modified_at timestamp not null default now();
alter table district add column modified_at timestamp not null default now();
alter table department add column modified_at timestamp not null default now();
alter table customer add column modified_at timestamp not null default now();
alter table city add column modified_at timestamp not null default now();
alter table branch add column modified_at timestamp not null default now();

alter table zone add column active boolean not null default true;
alter table supplier add column active boolean not null default true;
alter table state add column active boolean not null default true;
alter table sale_item add column active boolean not null default true;
alter table sale add column active boolean not null default true;
alter table product_group add column active boolean not null default true;
alter table product add column active boolean not null default true;
alter table marital_status add column active boolean not null default true;
alter table employee add column active boolean not null default true;
alter table district add column active boolean not null default true;
alter table department add column active boolean not null default true;
alter table customer add column active boolean not null default true;
alter table city add column active boolean not null default true;
alter table branch add column active boolean not null default true;

```

para popular usar o insert que está na pasta arquivos

```sql
-- update
update departamento set nome = 'Direção' where id = 6;
```

exercicio

```sql
-- Exercício
-- Fazer uma consulta para retornar todos os funcionários que contenham silva no nome;
-- Fazer um consulta para retornar todos os funcionários com o salário maior que R$ 5.000;
-- Fazer uma consulta para trazer todos os clientes que tem uma renda mensal inferior a R$ 2.000,00;
-- Fazer uma consulta para retornar todos os funcionários admitidos entre 2010 e 2021.

-- verifica o intervalo
select * from employee e
where id between 1 and 10;

select * from employee e
where e.name ilike ('%silva%');

select * from employee
where salary > 5000;

select * from customer c
where c.income < 2000;

select * from employee e
-- where e.admission_date between '2010-01-01' and '2021-12-31';
where date_part('year', e.admission_date) between 2010 and 2021;
```

exercicio 2

```sql
--Fazer uma consulta para retornar todos os funcionários casados ou solteiros;
select * from employee e
where e.id_marital_status = 1 or e.id_marital_status = 2;

select * from employee e
where e.id_marital_status in (1, 2);

-- Fazer uma consulta para retornar todos os funcionários que ganham entre R$ 1.000,00 e R$ 5.000,00;
select * from employee e
where e.salary between 1000 and 5000;

-- Fazer uma consulta que retorne a diferença do preço de custo e preçoe de venda dos produtos;
select
       p.name,
       p.cost_price,
       p.sale_price,
       p.sale_price - p.cost_price as diff
from product p;

-- Fazer uma consulta para retornar todos os funcionários que não tenham salário entre R$ 4.000,00 e R$ 8.000,00;
select * from employee e
where not e.salary between 4000 and 8000;
```

exercicio 3

```sql
-- Fazer uma consulta para retornar todos os clientes que já tenham alguma venda, não pode usar JOIN;
select *
from customer c
where exists(select distinct s.id_customer
    from sale s
    where s.id_customer = c.id);

-- Fazer uma consulta para retornar todos os funcionários que já tenham alguma venda, não pode usar JOIN;
select * from employee e
where e.id in (select distinct s.id_customer from sale s);

-- Fazer uma consulta para retornar todas as vendas entre 2010 e 2021 29/07/
select * from sale s
where date_part('year', s.date) between 2010 and 2021;
```

exercicio 4

```sql
select e.name, e.gender from employee e;

-- Fazer uma consulta para retornar o nome do funcionário e o sexo de forma descritiva;
select e.name,
    case
        when e.gender = 'M' then 'Masculino'
        else 'Feminino'
    end as sexo
from employee e;

-- Fazer uma consulta que retorne o tipo de funcionário de acordo com a sua idade;
-- 18 25 Jr.
-- 26 34 Pl.
-- 35 ou mais Sr.

-- com else
select
    e.name,
    case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
         when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
         when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
         else 'Menor Aprendiz'
    end as status
from employee e;

-- usando o where
select
    e.name,
    case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
         when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
         when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
    end as status
from employee e
where date_part('year', age(e.birth_date)) >= 18;

-- usando subquery 1
select * from
(
    select
        e.name,
        case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
             when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
             when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
        end as status
    from employee e
) as consulta
where consulta.status is not null;
```

exercicio 5

```sql
-- Exercício
-- Fazer uma consulta para retornar um status para o funcionário de acordo com o tempo de casa.
-- Até 2 anos Novato
-- Acima 2 anos e menor ou igual a 5 anos Intermediário
-- Acima de 5 anos Veterano

select
    e.name,
    case
        when date_part('year', age(e.admission_date)) <= 2 then 'Novato'
        when date_part('year', age(e.admission_date)) between 3 and 5 then 'Intermediário'
        else 'Veterano'
    end as status
from employee e
```

Join

```sql
-- alterar a tabela para tirar o not null
alter table employee
alter column id_department drop not null;

-- restartar o sequence
alter sequence employee_id_seq restart 301;

-- fazer o insert
insert into employee(id_district, id_marital_status, name, salary, admission_date, birth_date, gender)
values (1, 1, 'Abraão', 1000, current_date, current_date, 'M');

-- order by
select * from employee
order by id desc;

-- ver a quantidade
select count(*) from employee;

-- fazer o inner
select * from employee e
inner join department d on d.id = e.id_department;

-- observe que não apareceu o funcionario que estava sem departamento
```

```sql
-- vai prevalecer o lado esquerdo, mesmo não tendo departamento ele vai trazer o funcionario
select
    e.name,
    d.name as departamento
from employee e
left join department d on e.id_department = d.id

-- vai prevalecer o lado direito, mesmo não tendo departamento ele vai trazer o funcionario
select
    e.name,
    d.name as departamento
from department d
right join employee e on d.id = e.id_department
```

cross join

```sql
select * from department d
cross join marital_status;
```

exercicio

```sql
-- Exercícios
-- Fazer uma consulta para retornar o nome do funcionário e o bairro onde ele mora;
select e.name, d.name as bairro from employee e
inner join district d on d.id = e.id_district;

-- Fazer uma consulta para retornar o nome do cliente, cidade e zona que o mesmo mora;
select c.name, c2.name as cidade, z.name as zona from customer c
inner join district d on d.id = c.id_district
inner join city c2 on c2.id = d.id_city
inner join zone z on z.id = d.id_zone

-- Fazer uma consulta para retornar os dados da filial, estado e cidade onde a mesma está localizada;
select b.name, s.name as estado, c.name as cidade from branch b
inner join district d on d.id = b.id_district
inner join city c on c.id = d.id_city
inner join state s on s.id = c.id_state


-- Fazer uma consulta par retornar os dados do funcionário, departamento onde ele trabalha e qual seu estado civil atual;
select e.name as funcinario, ms.name as estado_civil, d.name as departamento from employee e
inner join department d on d.id = e.id_department
inner join marital_status ms on ms.id = e.id_marital_status
```

## Dia 4
Vamos agora ver algumas funções de string nativas do PostgreSQL que pode nos ajudar na resolução de alguns problemas.

![image-20210908142248302](C:\Users\abraao\study\curso_de_bd\assets\readme\image-20210908142248302.png)

![image-20210908142258794](C:\Users\abraao\study\curso_de_bd\assets\readme\image-20210908142258794.png)

![image-20210909133901298](C:\Users\abraao\study\curso_de_bd\assets\readme\image-20210909133901298.png)

exemplo de subquery

![image-20210909161355183](C:\Users\abraao\study\curso_de_bd\assets\readme\image-20210909161355183.png)

## dia 5

in, not in, exists e not exists

```sql
-- trazer todas as cidades que tiveram vendas no ano de 2020
select *
from city c
where c.id in (
    select d.id_city
    from sale s
             inner join branch b on b.id = s.id_branch
             inner join district d on d.id = b.id_district
    where date_part('year', s.date) = 2021
);

select *
from city c
where exists(
              select *
              from sale s
                       inner join branch b on b.id = s.id_branch
                       inner join district d on d.id = b.id_district
              where date_part('year', s.date) = 2021
                and d.id_city = c.id
          );

select *
from city c
where c.id = any (
    select d.id_city
    from sale s
             inner join branch b on b.id = s.id_branch
             inner join district d on d.id = b.id_district
    where date_part('year', s.date) = 2021
);

-- trazerr todos as zonas que não tiveram vendas no ano 2021
select *
from state s
where s.id not in (
    select c.id_state
    from sale s
             inner join branch b on b.id = s.id_branch
             inner join district d on d.id = b.id_district
             inner join city c on c.id = d.id_city
    where date_part('year', s.date) = 2020
);

select *
from state st
where not exists(
        select *
        from sale s
                 inner join branch b on b.id = s.id_branch
                 inner join district d on d.id = b.id_district
                 inner join city c on c.id = d.id_city
        where date_part('year', s.date) = 2020
          and st.id = c.id_state
    );
```

```sql
select *
from customer c
where c.id = all (select s.id_customer from sale s);

select *
from customer c
where row (c.id, c.active) in (select s.id_customer, s.active from sale s);

select *
from customer c
where exists(select * from sale s where c.id = s.id_customer and c.active = s.active);
```

## Dia 6

Hibridos
```sql
-- criar a tabela
create table cliente
(
    id        serial       not null primary key,
    nome      varchar(100) not null,
    telefones varchar[]
);

-- criar a tabela
create table cliente
(
    id        serial       not null primary key,
    nome      varchar(100) not null,
    telefones varchar(10)[]
);

-- ver todas as linhas da tabela
select *
from cliente c;

-- dropar tabela
drop table cliente;

--inserir elemento na tabela
insert into cliente(nome, telefones)
values ('Abraão Brandão', array ['0000-0000', '1111-1111']);

--consultar por posição do array
select c.nome, c.telefones[2], c.telefones[1]
from cliente c;

--adicionar elemento no array
update cliente set telefones = array_append(telefones, '2222-2222');
```

arrays
```sql
select array_append(array [1,2], 3);

select array_cat(array [1,2,3], array [4,5]);

select array_length(array [1,2,3], 1);

select array_position(array ['sun','mon','tue','wed','thu','fri','sat'], 'sun');

select array_positions(array ['A','B','A','C','D'], 'A');

select array_remove(array [1,2,3,2,4,5], 2);

select array_replace(array [1,2,5,4], 5, 3);

select array_to_string(array [1,2,3, NULL, 5], ',', '*');

select string_to_array('xx~~yy~~zz', '~~', 'yy');
```

json
```sql
drop table cliente;

create table cliente
(
    id                 serial       not null primary key,
    nome               varchar(100) not null,
    telefones          varchar(10)[],
    outras_informacoes jsonb
);

insert into cliente (nome, telefones, outras_informacoes)
values ('Abraão', array ['0000-0000'], '{
  "idade": 33,
  "email": "abraaobritof10@gmail.com"
}');

select *
from cliente c;

insert into cliente (nome, telefones, outras_informacoes)
values ('Gisele', array ['1111-1111'], '{
  "idade": 33,
  "email": "gih@gmail.com",
  "jogos": [
    "batlefield",
    "call of duty"
  ]
}');
```

```sql
drop table cliente;

create table cliente
(
    id                 serial       not null primary key,
    nome               varchar(100) not null,
    telefones          varchar(10)[],
    outras_informacoes jsonb
);

insert into cliente (nome, telefones, outras_informacoes)
values ('Abraão', array ['0000-0000'], '{
  "idade": 33,
  "email": "abraaobritof10@gmail.com"
}');

select *
from cliente c;

insert into cliente (nome, telefones, outras_informacoes)
values ('Gisele', array ['1111-1111'], '{
  "idade": 33,
  "email": "gih@gmail.com",
  "jogos": [
    "batlefield",
    "call of duty"
  ]
}');

select c.outras_informacoes -> 'jogos'
from cliente c;

update cliente
set outras_informacoes = outras_informacoes || '{"cpf": "000.000.000-00"}';

update cliente
set outras_informacoes = outras_informacoes || '{"cpf": "000.000.000-55"}'
where id = 2;

update cliente c
set outras_informacoes = outras_informacoes || '{"telefones": [' + c.telefones + '}' where c.id = 1;
```

type
```sql
create type informacoes as
(
    cpf   varchar(11),
    email varchar(256)
);

create table cliente
(
    id    serial       not null primary key,
    nome  varchar(100) not null,
    dados informacoes
);

drop table cliente;

select *
from cliente;

insert into cliente(nome, dados) values ('Abraao', row ('00000000000', 'abraao#gmail.com'))

select (dados).cpf from cliente;
```