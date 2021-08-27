-- Exercício
-- Fazer uma consulta para retornar um status para o funcionário de acordo com o tempo de casa.
-- Até 2 anos Novato
-- Acima 2 anos e menor ou igual a 5 anos Intermediário
-- Acima de 5 anos Veterano

select
    e.name,
    case
        when date_part('year', age(e.admission_date)) <= 2 then 'Novato'
        when date_part('year', age(e.admission_date)) between 3 and 5 then 'Intermediário'
        else 'Veterano'
    end as status
from employee e;