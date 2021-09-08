-- Fazer uma consulta para retornar os 5 funcionários mais bem pagos juntamente com os 5 clientes com as melhores rendas mensais;

select *
from (
         select e.name, e.salary
         from employee e
         order by e.salary desc
         limit 5
     ) as emp
union
select *
from (
         select c.name, c.income
         from customer c
         order by c.income desc
         limit 5
     ) as cus;

-- Fazer uma consulta que retorne as 5 pessoas com piores rendas ou salários;
select *
from (
         select e.name, e.salary
         from employee e
         order by e.salary asc
         limit 5
     ) as emp
union
select *
from (
         select c.name, c.income
         from customer c
         order by c.income asc
         limit 5
     ) as cus;

-- Fazer uma consulta para retornar as 50 mulheres mais bem pagas entre funcionários e clientes;
(
    select c.name, c.income as valor
    from customer c
    where c.gender = 'F'
    order by c.income desc
)
union
(
    select e.name, e.salary as valor
    from employee e
    where e.gender = 'F'
    order by e.salary desc
)
order by valor desc
limit 50;