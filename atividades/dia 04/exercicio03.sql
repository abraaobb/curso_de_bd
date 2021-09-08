-- Criar uma consulta para trazer o primeiro nome dos funcionários.
-- Sr. Sra. Dr. Dra. remover se tiver.

select substring(foo.nome_replace, 1, position(' ' in foo.nome_replace))
from (
         select trim(replace(replace(replace(replace(replace(e.name, 'Sr.', ''), 'Sra.', ''), 'Dr.', ''), 'Dra.', ''),
                             'Srta.', '')) as nome_replace
         from employee e
     ) as foo;


-- Criar uma consulta para trazer o último nome dos clientes.

select 


--Criar um uma consulta que retorne os comandos para atualizar o nome de cada funcionário para o NOME SALÁRIO.

--Criar uma consulta para rocar quem tenha silva no nome para Oliveira.