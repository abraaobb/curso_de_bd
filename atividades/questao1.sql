CREATE TABLE venda (
	id serial NOT NULL,
	id_cliente int(4) not null,
	id_funcionario int(4) not null,
	id_relacao int(4) not null,
	data timestamp(6) not null,
	criado_em timestamp not null default now(),
	modificado_em timestamp not null default now(),
	is_ativo bool not null default true
) partition by range(data);

alter table venda add constraint fk_venda_cliente foreign key (id_cliente) REFERENCES cliente(id);
alter table venda add constraint fk_venda_funcionario foreign key (id_funcionario) REFERENCES funcionario(id);
alter table venda add constraint fk_venda_relacao foreign key (id_relacao) REFERENCES relacao(id);

select * from sale;