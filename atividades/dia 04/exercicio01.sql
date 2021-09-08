-- Ranking dos 10 funcionários mais bem pagos;
select *
from employee
order by salary desc
limit 10;

-- Ranking dos 20 clientes que tem a menor renda mensal;
select *
from customer
order by income asc
limit 20;

-- Trazer do décimo primeiro ao vigésimo funcionário mais bem pago;
select *
from employee
order by salary desc
limit 10 offset 10;

-- Ranking dos produtos mais caros vendidos no ano de 2021;
select p.name, p.sale_price
from product p
where exists (select * from sale s
    inner join sale_item si on s.id = si.id_sale
    where date_part('year', s, date) = 2021 and si.id_product = p.id)