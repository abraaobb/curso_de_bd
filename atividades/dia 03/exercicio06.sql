-- Exercícios
-- Fazer uma consulta para retornar o nome do funcionário e o bairro onde ele mora;
select e.name, d.name as bairro from employee e
inner join district d on d.id = e.id_district;

-- Fazer uma consulta para retornar o nome do cliente, cidade e zona que o mesmo mora;
select c.name, c2.name as cidade, z.name as zona from customer c
inner join district d on d.id = c.id_district
inner join city c2 on c2.id = d.id_city
inner join zone z on z.id = d.id_zone

-- Fazer uma consulta para retornar os dados da filial, estado e cidade onde a mesma está localizada;
select b.name, s.name as estado, c.name as cidade from branch b
inner join district d on d.id = b.id_district
inner join city c on c.id = d.id_city
inner join state s on s.id = c.id_state


-- Fazer uma consulta par retornar os dados do funcionário, departamento onde ele trabalha e qual seu estado civil atual;
select e.name as funcinario, ms.name as estado_civil, d.name as departamento from employee e
inner join department d on d.id = e.id_department
inner join marital_status ms on ms.id = e.id_marital_status