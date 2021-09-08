--Fazer uma consulta para retornar todos os funcionários casados ou solteiros;
select * from employee e
where e.id_marital_status = 1 or e.id_marital_status = 2;

select * from employee e
where e.id_marital_status in (1, 2);

-- Fazer uma consulta para retornar todos os funcionários que ganham entre R$ 1.000,00 e R$ 5.000,00;
select * from employee e
where e.salary between 1000 and 5000;

-- Fazer uma consulta que retorne a diferença do preço de custo e preçoe de venda dos produtos;
select
       p.name,
       p.cost_price,
       p.sale_price,
       p.sale_price - p.cost_price as diff
from product p;

-- Fazer uma consulta para retornar todos os funcionários que não tenham salário entre R$ 4.000,00 e R$ 8.000,00;
select * from employee e
where not e.salary between 4000 and 8000;