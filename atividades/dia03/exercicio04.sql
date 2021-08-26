select e.name, e.gender from employee e;

-- Fazer uma consulta para retornar o nome do funcionário e o sexo de forma descritiva;
select e.name,
    case
        when e.gender = 'M' then 'Masculino'
        else 'Feminino'
    end as sexo
from employee e;

-- Fazer uma consulta que retorne o tipo de funcionário de acordo com a sua idade;
-- 18 25 Jr.
-- 26 34 Pl.
-- 35 ou mais Sr.

-- com else
select
    e.name,
    case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
         when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
         when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
         else 'Menor Aprendiz'
    end as status
from employee e;

-- usando o where
select
    e.name,
    case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
         when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
         when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
    end as status
from employee e
where date_part('year', age(e.birth_date)) >= 18;

-- usando subquery 1
select * from
(
    select
        e.name,
        case when date_part('year', age(e.birth_date)) between 18 and 25 then 'Jr.'
             when date_part('year', age(e.birth_date)) between 26 and 34 then 'Pl.'
             when date_part('year', age(e.birth_date)) >= 35 then 'Sr.'
        end as status
    from employee e
) as consulta
where consulta.status is not null;