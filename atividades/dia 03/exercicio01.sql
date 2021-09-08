-- Exercício
-- Fazer uma consulta para retornar todos os funcionários que contenham silva no nome;
-- Fazer um consulta para retornar todos os funcionários com o salário maior que R$ 5.000;
-- Fazer uma consulta para trazer todos os clientes que tem uma renda mensal inferior a R$ 2.000,00;
-- Fazer uma consulta para retornar todos os funcionários admitidos entre 2010 e 2021.

-- verifica o intervalo
select * from employee e
where id between 1 and 10;

select * from employee e
where e.name ilike ('%silva%');

select * from employee
where salary > 5000;

select * from customer c
where c.income < 2000;

select * from employee e
where e.admission_date between '2010-01-01' and '2021-12-31';