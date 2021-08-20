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

