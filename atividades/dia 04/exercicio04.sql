select e.gender, count(*) as quantidade, avg(e.salary)
from employee e
group by e.gender
having count(*) > 150;

-- Criar uma consulta para trazer o total de funcionários por estado civil;

select ms.name, count(*)
from employee e
         inner join marital_status ms on ms.id = e.id_marital_status
group by ms.name;


-- Criar uma consulta para trazer o total vendido em valor R$ por filial;

select b.name, sum(si.quantity * p.sale_price)
from branch b
         inner join sale s on b.id = s.id_branch
         inner join sale_item si on s.id = si.id_sale
         inner join product p on p.id = si.id_product
group by b.name;

-- Trazer a media de salários por sexo, o sexo deve está de forma descritiva;

select case
           when e.gender = 'M' then 'Masculino'
           else 'Feminino'
           end                 as sexo,
       round(avg(e.salary), 2) as total
from employee e
group by 1;

-- Uma consulta para trazer a média de salários por departamento;

select d.name,
       avg(e.salary)
from employee e
         inner join department d on d.id = e.id_department
group by d.name;

-- Uma consulta para trazer o total vendido em valor por ano;

select extract('year' from s.date)     as ano,
       sum(si.quantity * p.sale_price) as subtotal
from sale s
         inner join sale_item si on s.id = si.id_sale
         inner join product p on p.id = si.id_product
group by ano
order by ano;

-- Uma consulta para trazer o total vendido em valor por idade de funcionário;

select date_part('year', age(e.birth_date)) as idade,
       sum(si.quantity * p.sale_price)      as subtotal
from sale s
         inner join sale_item si on s.id = si.id_sale
         inner join product p on p.id = si.id_product
         inner join employee e on e.id = s.id_employee
group by idade
order by idade;

-- Criar uma consulta para trazer o total vendido em quantidade por
-- cidade, trazer apenas as cidades que tiveram vendas acima de
-- quantidade 100;

select c.name,
       sum(si.quantity) as total
from sale s
         inner join branch b on b.id = s.id_branch
         inner join district d on d.id = b.id_district
         inner join city c on c.id = d.id_city
         inner join sale_item si on s.id = si.id_sale
group by c.name;

-- Fazer uma consulta que retorne os 5 grupos de produtos mais
-- lucrativos em termos de valor, os grupos só entram na lista com lucros
-- acima de R$ 200,00;

select pg.name,
       round(sum((si.quantity * p.sale_price) / pg.gain_percentage)) as lucro
from sale_item si
         inner join product p on p.id = si.id_product
         inner join product_group pg on pg.id = p.id_product_group
group by pg.name
having round(sum((si.quantity * p.sale_price) / pg.gain_percentage), 2)
order by lucro desc