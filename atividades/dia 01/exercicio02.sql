-- CHECK
-- Exercício
-- Criar uma coluna para o preço de custo do produto;
-- Criar uma regra para que o campo preço de custo seja maior que 0;
-- Criar uma regra para que o campo preço de venda seja maior que 0;
-- Criar uma regra para que o preço de venda seja maior que o preço de custo;

select * from produto;

drop table produto;

create table produto(
    id serial not null,
	nome varchar(104) not null,
	preco_venda numeric(10,2) not null default 10.00,
	ativo boolean not null default true
);

alter table produto add column preco_custo numeric (10,2);

alter table produto add constraint check_preco_venda check (preco_venda > 0);

alter table produto add constraint check_preco_custo check (preco_custo > 0);

alter table produto add constraint check_produto_preco_venda_maior_custo check (preco_venda > preco_custo);

insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', -1, 1000);

insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', 900, 1000);

insert into produto (nome, preco_venda, preco_custo) values ('Note Dell', 1100, 1000);