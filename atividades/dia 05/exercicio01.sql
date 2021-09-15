-- Criar uma consulta pra trazer todas as zonas que possuem vendas no ano de 2012 baseado no cliente;

select *
from zone z
where exists(
              select *
              from sale s
                       inner join customer c on c.id = s.id_customer
                       inner join district d on d.id = c.id_district
              where date_part('year', s.date) = 2012
                and z.id = d.id_zone
          );


-- Criar uma consulta para trazer todas as filiais que possuem uma venda no ano de 2013 para o grupo de produtos Alimentício;

select *
from branch b
where exists(
              select *
              from sale s
                       inner join sale_item si on s.id = si.id_sale
                       inner join product p on p.id = si.id_product
                       inner join product_group pg on pg.id = p.id_product_group
              where date_part('year', s.date) = 2013
                and pg.name = 'Alimentício'
                and s.id_branch = b.id
          );

-- Criar uma consulta para trazer o total vendido por sexo nos anos de 2010, 2011, 2012, 2013, 2014, 2015, cada ano deve ser representado como uma coluna da sua consulta (cliente);
select case when consulta.sexo = 'F' then 'Feminino' else 'Masculino' end as sexo,
       (
           select sum(p.sale_price * si.quantity)
           from sale s
                    inner join customer c on c.id = s.id_customer
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where date_part('year', s.date) = 2010
             and c.gender = consulta.sexo
       )
                                                                          as ano_2010,
       (
           select sum(p.sale_price * si.quantity)
           from sale s
                    inner join customer c on c.id = s.id_customer
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where date_part('year', s.date) = 2011
             and c.gender = consulta.sexo
       )
                                                                          as ano_2011
from (
         select unnest(array ['M', 'F']) as sexo
     ) as consulta;


-- Criar uma consulta para trazer todos os produtos que não foram vendidos no ano de 2020;

select *
from product p
where not exists(
        select *
        from sale s
                 inner join sale_item si on s.id = si.id_sale
        where date_part('year', s.date) = 2020
          and p.id = si.id_product
    );


-- extra

select consulta.ano,
       (
           select sum(p.sale_price * si.quantity)
           from sale s
                    inner join customer c on c.id = s.id_customer
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where date_part('year', s.date) = consulta.ano
             and c.gender = 'M'
       )
           as sexo_masculino,
       (
           select sum(p.sale_price * si.quantity)
           from sale s
                    inner join customer c on c.id = s.id_customer
                    inner join sale_item si on s.id = si.id_sale
                    inner join product p on p.id = si.id_product
           where date_part('year', s.date) = consulta.ano
             and c.gender = 'F'
       )
           as sexo_feminino
from (
         select unnest(array [2010,2011,2012,2013]) as ano
     ) as consulta;

2:28