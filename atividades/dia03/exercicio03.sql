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