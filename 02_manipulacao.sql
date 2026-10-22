
USE lavanderia;

-- ---------------------------------------------------------------------
-- A. SELECT SIMPLES (3)
-- ---------------------------------------------------------------------

-- A1. Clientes que vivem no bairro Macúti, por ordem alfabética.
-- ESPERADO: 3 linhas (Fátima Domingos Cossa, Maria Fernanda Sitoe,
--           Rogério Tomás Nhamussua).
SELECT id_cliente, nome, telefone
FROM cliente
WHERE endereco LIKE '%Macúti%'
ORDER BY nome ASC;

-- A2. Pedidos ainda não entregues, ordenados pela data de entrega prevista.
-- ESPERADO: 4 linhas: pedidos 17 e 18 (Pronto, 22/10), 19 (Em processamento,
--           23/10) e 20 (Em processamento, 24/10).
SELECT id_pedido, data_recepcao, data_entrega_prevista, estado, total
FROM pedido
WHERE estado IN ('Pronto','Em processamento')
ORDER BY data_entrega_prevista ASC, id_pedido ASC;

-- A3. Serviços com preço superior a 100 MT, do mais caro para o mais barato.
-- ESPERADO: 10 linhas, a começar em "Lavagem de tapetes" (300) e a terminar
--           em "Lavagem de vestido" (120).
SELECT nome, preco_unitario
FROM servico
WHERE preco_unitario > 100
ORDER BY preco_unitario DESC;

-- ---------------------------------------------------------------------
-- B. SELECT COM JOIN (2)
-- ---------------------------------------------------------------------

-- B1. Lista de pedidos com o nome do cliente e do funcionário que os registou.
-- ESPERADO: 20 linhas (todos os pedidos têm cliente e funcionário).
--           Ex.: pedido 1 -> Maria Fernanda Sitoe, registado por Joana Matsinhe.
SELECT p.id_pedido, p.data_recepcao, p.estado, p.total,
       c.nome AS cliente, u.nome AS funcionario
FROM pedido p
JOIN cliente   c ON c.id_cliente    = p.id_cliente
JOIN utilizador u ON u.id_utilizador = p.id_utilizador
ORDER BY p.id_pedido;

-- B2. Detalhe dos itens do pedido 1 (serviço, tipo de peça e subtotal).
-- ESPERADO: 2 linhas: 5 Camisas com "Lavagem e secagem" = 350.00 MT e
--           3 Calças com "Passar a ferro" = 90.00 MT (total 440.00).
SELECT i.nr_item, t.nome AS peca, s.nome AS servico, i.quantidade,
       s.preco_unitario, (i.quantidade * s.preco_unitario) AS subtotal
FROM item_pedido i
JOIN servico   s ON s.id_servico   = i.id_servico
JOIN tipo_peca t ON t.id_tipo_peca = i.id_tipo_peca
WHERE i.id_pedido = 1;

-- B3 (extra, útil para o sistema web). Pedidos com saldo por pagar.
-- ESPERADO: 3 linhas: pedido 17 (saldo 240.00), 19 (saldo 240.00) e
--           20 (saldo 260.00).
SELECT p.id_pedido, c.nome AS cliente, p.total,
       COALESCE(SUM(g.valor),0) AS pago,
       p.total - COALESCE(SUM(g.valor),0) AS saldo
FROM pedido p
JOIN cliente c ON c.id_cliente = p.id_cliente
LEFT JOIN pagamento g ON g.id_pedido = p.id_pedido
GROUP BY p.id_pedido, c.nome, p.total
HAVING saldo > 0
ORDER BY p.id_pedido;

-- ---------------------------------------------------------------------
-- C. UPDATE (2)
-- ---------------------------------------------------------------------

-- C1. A secagem do pedido 20 terminou: registar o fim e marcar como "Pronto".
-- ESPERADO: 1 linha alterada em cada comando (Rows matched: 1, Changed: 1).
UPDATE processamento
SET data_fim = '2026-10-21 11:30'
WHERE id_processamento = 22;

UPDATE pedido
SET estado = 'Pronto'
WHERE id_pedido = 20;

-- C2. A Lavadora 7 foi reparada: passa a disponível.
-- ESPERADO: 1 linha alterada (id_maquina 20: de 'avariada' para 'disponivel').
UPDATE maquina
SET estado = 'disponivel'
WHERE id_maquina = 20;

-- Conferir os resultados dos UPDATE:
SELECT id_pedido, estado FROM pedido WHERE id_pedido = 20;
SELECT id_maquina, nome, estado FROM maquina WHERE id_maquina = 20;

-- ---------------------------------------------------------------------
-- D. DELETE (1) - respeitando as chaves estrangeiras
-- ---------------------------------------------------------------------

-- D1. O pedido 19 foi registado por engano e vai ser eliminado.
-- A tabela processamento referencia o pedido (sem CASCADE), por isso
-- primeiro apagamos o processamento; os itens são apagados automaticamente
-- (ON DELETE CASCADE, por serem entidade fraca) e só depois o pedido.
-- ESPERADO: 1 linha apagada em processamento (id 21), 1 linha apagada em
--           pedido; os 2 itens do pedido 19 desaparecem em cascata.
DELETE FROM processamento WHERE id_pedido = 19;
DELETE FROM pedido        WHERE id_pedido = 19;

-- Conferir: ambos devem devolver 0 linhas.
SELECT * FROM pedido       WHERE id_pedido = 19;
SELECT * FROM item_pedido  WHERE id_pedido = 19;

-- ---------------------------------------------------------------------
-- E. TESTE DE INTEGRIDADE (1)
-- ---------------------------------------------------------------------

-- E1. Tentar registar um pedido para um cliente que não existe (id 999).
-- ESPERADO: ERRO 1452 - "Cannot add or update a child row: a foreign key
--           constraint fails (fk_pedido_cliente)". O SGBD recusa, porque
--           a chave estrangeira id_cliente tem de apontar para um cliente
--           existente na tabela cliente. Nenhum registo é inserido.
INSERT INTO pedido (data_recepcao, data_entrega_prevista, estado, total, id_cliente, id_utilizador)
VALUES ('2026-10-22','2026-10-24','Recebido',100.00, 999, 4);
