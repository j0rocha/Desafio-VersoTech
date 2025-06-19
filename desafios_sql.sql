-- query desafio 1
SELECT id_vendedor AS id, nome, salario FROM vendedores
WHERE inativo = FALSE
ORDER BY nome ASC;

-- query desafio 2
SELECT id_vendedor AS id, nome, salario FROM vendedores
WHERE salario > (SELECT AVG(salario) FROM vendedores)
ORDER BY salario DESC;

-- query desafio 3
SELECT
  id_cliente AS id,
  razao_social,
  COALESCE(CAST((SELECT SUM(valor_total)
    FROM pedido
    WHERE pedido.id_cliente = clientes.id_cliente) AS INTEGER), 0) AS total FROM clientes
ORDER BY total DESC;

-- query desafio 4
SELECT 
  id_pedido AS id, 
  valor_total AS valor, 
  data_emissao AS data,
  CASE
    WHEN data_cancelamento IS NOT NULL THEN 'CANCELADO'
    WHEN data_faturamento IS NOT NULL THEN 'FATURADO'
    ELSE 'PENDENTE'
  END AS situacao
FROM pedido;

-- query desafio 5 
SELECT
  ip.id_produto,
  (SELECT SUM(quantidade) FROM itens_pedido WHERE id_produto = ip.id_produto) AS quantidade_vendida,
  CAST((SELECT SUM(quantidade * preco_praticado) FROM itens_pedido WHERE id_produto = ip.id_produto) AS INTEGER) AS total_vendido,
  (SELECT COUNT(DISTINCT id_pedido) FROM itens_pedido WHERE id_produto = ip.id_produto) AS pedidos,
  (SELECT COUNT(DISTINCT p.id_cliente)
   FROM pedido p
   JOIN itens_pedido ip2 ON p.id_pedido = ip2.id_pedido
   WHERE ip2.id_produto = ip.id_produto) AS clientes
FROM itens_pedido ip
GROUP BY ip.id_produto
ORDER BY quantidade_vendida DESC, total_vendido DESC
LIMIT 1;