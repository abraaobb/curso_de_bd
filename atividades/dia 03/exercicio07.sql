-- Fazer uma consulta para retornar o nome do produto vendido, o preço unitário e o subtotal;
select p.name as nome, p.cost_price as preco_custo, p.sale_price as preco_venda, p.cost_price * s.quantity as subtotal
from sale_item s
         join product p on s.id_product = p.id;

-- Fazer uma consulta para retornar o nome do produto, subtotal e quanto deve ser pago de comissão por cada item;
select p.name, s.quantity
from sale_item s
         join product p on p.id = s.id_product;
-- Fazer uma consulta para retornar o nome do produto, subtotal e quanto foi obtido de lucro por item;
select p.name as nome, p.cost_price * s.quantity as subtotal, p.sale_price - p.cost_price as lucro
from sale_item s
         join product p on s.id_product = p.id;
-- Criar um bloco anônimo que retorne o total de salário dos funcionários homens e total de salário das mulheres;
do
$$
declare
	sal_homem integer default 0;
    sal_mulher integer default 0;
    contador integer default 1;

begin
	while contador <= 100 loop
-- 		raise notice 'contador: %', contador;
		contador := contador + 1;
        sal_homem := sal_homem +
	end loop;
end;
$$