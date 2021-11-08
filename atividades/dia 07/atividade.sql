create or replace function fn_perfil(salario numeric) returns varchar as
$$
declare
    perfil varchar default '';
begin
    case when salario between 0 and 2000 then
        perfil := 'Jr.';
    when salario between 2001 and 5000 then
        perfil := 'Pl.';
    else
        perfil := 'Sr.';
    end case;
    return perfil;
end;
$$
    language plpgsql;

select e.name, e.salary, fn_perfil(e.salary) from employee e;

