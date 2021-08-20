select * from crosstab(
    $$
    select b.nome,
    z.nome, 
    count(c.id) filter (where z.id = b.id_zone )
    from public.bairro b
        inner join public.cliente c on d.id = c.id_bairro
        cross join public.zona z 
    group by 1,2
    order by 1,2
    $$,
    $$
        select name from public.zona
    $$
    ) as (name varchar, Norte varchar, Sul varchar, Leste varchar, Oeste varchar)