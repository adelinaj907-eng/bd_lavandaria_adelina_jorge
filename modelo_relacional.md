# Modelo Relacional — Base de Dados da Lavandaria

Legenda: **PK** = chave primária · **FK** = chave estrangeira · **UQ** = valor único · **NN** = não nulo

## Tabelas

### utilizador
| Atributo | Tipo | Restrições |
|---|---|---|
| id_utilizador | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(80) | NN |
| email | VARCHAR(100) | NN, UQ |
| palavra_passe | VARCHAR(64) | NN (hash SHA-256) |
| perfil | ENUM('administrador','funcionário') | NN, padrão 'funcionário' |

### cliente
| Atributo | Tipo | Restrições |
|---|---|---|
| id_cliente | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(80) | NN |
| telefone | VARCHAR(15) | NN, UQ |
| endereco | VARCHAR(120) | NN |

### servico
| Atributo | Tipo | Restrições |
|---|---|---|
| id_servico | INT AUTO_INCREMENT | PK |
| nome | VARCHAR(60) | NN, UQ |
| descricao | VARCHAR(150) | — |
| preco_unitario | DECIMAL(10,2) | NN, CHECK (> 0) |

### pedido  (a confirmar com o script)
| Atributo | Tipo | Restrições |
|---|---|---|
| id_pedido | INT AUTO_INCREMENT | PK |
| data_recepcao | DATE | NN |
| data_entrega_prevista | DATE | NN |
| estado | VARCHAR(20) | NN |
| total | DECIMAL(10,2) | NN |
| id_cliente | INT | FK → cliente(id_cliente), NN |
| id_utilizador | INT | FK → utilizador(id_utilizador), NN |

### item_pedido  (entidade fraca — a confirmar com o script)
| Atributo | Tipo | Restrições |
|---|---|---|
| id_pedido | INT | PK, FK → pedido(id_pedido) |
| id_servico | INT | PK, FK → servico(id_servico) |
| quantidade | INT | NN, CHECK (> 0) |
| preco_aplicado | DECIMAL(10,2) | NN |

## Notação resumida

```
utilizador (id_utilizador, nome, email, palavra_passe, perfil)
cliente    (id_cliente, nome, telefone, endereco)
servico    (id_servico, nome, descricao, preco_unitario)
pedido     (id_pedido, data_recepcao, data_entrega_prevista, estado, total,
            #id_cliente, #id_utilizador)
item_pedido(#id_pedido, #id_servico, quantidade, preco_aplicado)
```

(`#` indica chave estrangeira; os atributos sublinhados na entrega final são as PK.)

## Relacionamentos

| Relacionamento | Cardinalidade | Participação |
|---|---|---|
| cliente **faz** pedido | 1 : N | cliente parcial, pedido total |
| utilizador **regista** pedido | 1 : N | utilizador parcial, pedido total |
| pedido **contém** item_pedido | 1 : N | item_pedido total (entidade fraca) |
| servico **aparece em** item_pedido | 1 : N | servico parcial, item_pedido total |
| pedido ↔ servico (via item_pedido) | N : M | — |
