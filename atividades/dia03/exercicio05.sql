select
    e.name,
    case
        when date_part('year', age(e.admission_date)) <= 2 then 'Novato'
        when date_part('year', age(e.admission_date)) between 3 and 5 then 'Intermediário'
        else 'Veterano'
    end as status
from employee e