-- Criar uma consulta para trazer todos produtos que foram vendidos para clientes que não são casados no ano de 2015;
select p.name
from product p
where exists(
              select *
              from sale s
                       inner join sale_item si on s.id = si.id_sale
                       inner join customer c on c.id = s.id_customer
              where date_part('year', s.date) = 2015
                and c.id_marital_status <> (2)
                and si.id_product = p.id
          );

-- Criar uma consulta para trazer o total de lucro por grupo de produto do ano de 2016 inteiro, cada mês deve ser considerado uma coluna em seu SQL;
select pg.name, sum((si.quantity * p.sale_price) * pg.gain_percentage / 100)
from sale s
         inner join sale_item si on s.id = si.id_sale
         inner join product p on p.id = si.id_product
         inner join product_group pg on pg.id = p.id_product_group
group by 1;

select pge.name,
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 1
             and date_part('year', s.date) = 2016
       ) as "01/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 2
             and date_part('year', s.date) = 2016
       ) as "02/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 3
             and date_part('year', s.date) = 2016
       ) as "03/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 4
             and date_part('year', s.date) = 2016
       ) as "04/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 5
             and date_part('year', s.date) = 2016
       ) as "05/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 6
             and date_part('year', s.date) = 2016
       ) as "06/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 7
             and date_part('year', s.date) = 2016
       ) as "07/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 8
             and date_part('year', s.date) = 2016
       ) as "08/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 9
             and date_part('year', s.date) = 2016
       ) as "09/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 10
             and date_part('year', s.date) = 2016
       ) as "10/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 11
             and date_part('year', s.date) = 2016
       ) as "11/2016",
       (
           select sum((si.quantity * p.sale_price) * pge.gain_percentage / 100)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where p.id_product_group = pge.id
             and date_part('month', s.date) = 12
             and date_part('year', s.date) = 2016
       ) as "12/2016"
from product_group pge;

-- Criar uma consulta para trazer todos os fornecedores que não tiveram seus produtos vendidos no ano de 2021;
select *
from supplier sp
where not exists(
        select *
        from sale s
                 inner join sale_item si on s.id = si.id_sale
                 inner join product p on p.id = si.id_product
        where p.id_supplier = sp.id
          and date_part('year', s.date) = 2021
    );

-- Criar uma consulta com uma lista de produtos que foram vendidos no ano de 2019, deve ser exibido uma coluna que identifica o total vendido em quantidade por produto e estado civil, cada estado civil deve ser uma coluna diferente em sua consulta;
select p.name,
       (
           select sum(si.quantity)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join customer c on c.id = s.id_customer
           where si.id_product = p.id
             and c.id_marital_status = 1
             and date_part('year', s.date) = 2019
       ) as solteiro,
       (
           select sum(si.quantity)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join customer c on c.id = s.id_customer
           where si.id_product = p.id
             and c.id_marital_status = 2
             and date_part('year', s.date) = 2019
       ) as casado,
       (
           select sum(si.quantity)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join customer c on c.id = s.id_customer
           where si.id_product = p.id
             and c.id_marital_status = 3
             and date_part('year', s.date) = 2019
       ) as divorciado,
       (
           select sum(si.quantity)
           from sale s
                    inner join sale_item si on s.id = si.id_sale
                    inner join customer c on c.id = s.id_customer
           where si.id_product = p.id
             and c.id_marital_status = 4
             and date_part('year', s.date) = 2019
       ) as viuvo
from product p
where exists(
              select *
              from sale s
                       inner join sale_item si on s.id = si.id_sale
              where date_part('year', s.date) = 2019
          );