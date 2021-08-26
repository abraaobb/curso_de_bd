-- Exercício
-- Criar um schema vendas onde nossa tabela deverá ser criada;
-- Criar uma tabela de fornecedor com NOME, CNPJ, não é para criar chave primárias nesse momento;
-- Adicionar uma coluna para identificar se o registro está ou não ativo, o valor default deve ser verdadeiro;
-- Adicionar uma coluna para data de cadastro, o valor default deve ser a data atual;
-- Criar um sequence para controlar o incremento do ID da tabela fornecedor;
-- Criar uma coluna ID e definir ela como chave primária da tabela de fornecedor e setar o valor default com o sequence.

create schema vendas;

create table vendas.fornecedor(
    nome varchar(104) not null,
    cnpj varchar(11) not null
);

alter table vendas.fornecedor add column is_ativo bool not null default true;

alter table vendas.fornecedor add column created_at timestamp not null default now();

create sequence vendas.fornecedor_id_seq start 1 increment 1;

alter table vendas.fornecedor add column id integer not null;

alter table vendas.fornecedor alter column id set default nextval('vendas.fornecedor_id_seq');

alter table vendas.fornecedor add constraint  pk_fornecedor primary key (id);