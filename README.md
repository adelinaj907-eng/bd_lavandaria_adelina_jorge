# Base de Dados de uma Lavandaria

**Disciplina:** Tecnologias de Base de Dados — 2º ano, Licenciatura em Informática
**Trabalho:** Projecto de uma Base de Dados
**Estudante:** adelina jorge jo manuel
**Tema:** Gestão de uma lavandaria




**Vídeo de apresentação:** 

---

## 1. Descrição do problema

Escolhi como tema uma lavandaria, porque é um negócio do dia a dia que conheço e que consigo imaginar bem a funcionar. Uma lavandaria recebe roupa de vários clientes (camisas, vestidos, fatos, cobertores, tapetes) para lavar, passar a ferro ou tratar, e depois entrega-a numa data combinada.

O problema é que muitas lavandarias ainda registam tudo em cadernos. Assim, os pedidos podem perder-se, é difícil saber em que estado está cada um, o valor a cobrar pode ter enganos e não dá para consultar rapidamente o histórico de um cliente.

Com a minha base de dados, quero resolver isso. O sistema permite:

- registar os **clientes** (nome, telefone e endereço);
- guardar o catálogo de **serviços**, cada um com o seu preço unitário;
- registar cada **pedido**, com a data de recepção, a data de entrega prevista, o estado e o total a pagar;
- indicar, em cada pedido, **quais os serviços pedidos e em que quantidade**;
- controlar quem usa o sistema, através de **utilizadores** que são administradores ou funcionários, e saber quem registou cada pedido.

Assim, a lavandaria passa a saber que pedidos faltam entregar, quanto fatura, que serviços são mais pedidos e quem são os clientes habituais.

## 2. Regras de negócio

Estas foram as regras que usei para desenhar o modelo:

1. Um cliente pode fazer vários pedidos, mas cada pedido pertence a um só cliente.
2. O telefone de cada cliente é único, para não haver dois clientes com o mesmo número.
3. Cada pedido é registado por um utilizador do sistema (funcionário ou administrador).
4. O email de cada utilizador é único, e a palavra-passe guarda-se em hash (SHA-256), nunca em texto simples.
5. Um utilizador tem um de dois perfis: administrador ou funcionário (por omissão, funcionário).
6. Cada serviço tem um nome único e um preço unitário maior que zero.
7. Um pedido tem pelo menos um serviço, e o mesmo serviço pode aparecer em vários pedidos.
8. Em cada serviço de um pedido guardo a quantidade e o preço aplicado, para que mudanças futuras no preço do serviço não alterem pedidos antigos.
9. A data de entrega prevista não pode ser anterior à data de recepção.
10. Um pedido é eliminado juntamente com os seus serviços, porque não pode existir um serviço de pedido sem pedido.

## 3. Modelo de dados

- **Diagrama ER:** [`diagrama_er.png`](diagrama_er.png)
- **Modelo relacional:** [`modelo_relacional.md`](modelo_relacional.md)

Resumo do modelo relacional (`#` indica chave estrangeira):

```
utilizador  (id_utilizador, nome, email, palavra_passe, perfil)
cliente     (id_cliente, nome, telefone, endereco)
servico     (id_servico, nome, descricao, preco_unitario)
pedido      (id_pedido, data_recepcao, data_entrega_prevista, estado, total,
             #id_cliente, #id_utilizador)
item_pedido (#id_pedido, #id_servico, quantidade, preco_aplicado)
```

A entidade fraca é `item_pedido`: só existe dentro de um pedido, e a sua chave primária inclui `id_pedido`.

## 4. Sistema web que pretendo desenvolver

Na disciplina de Programação Web, vou usar esta mesma base de dados para criar um sistema web de gestão da lavandaria.

**Quem vai usar o sistema:**
- **Funcionário:** regista clientes e pedidos e actualiza o estado dos pedidos.
- **Administrador:** faz tudo o que o funcionário faz e também gere os serviços, os preços e os utilizadores.

**O que o sistema vai fazer:**
- iniciar sessão com email e palavra-passe;
- registar, listar, pesquisar, alterar e eliminar clientes;
- gerir o catálogo de serviços e preços;
- registar um pedido com vários serviços e calcular o total;
- listar e pesquisar pedidos por cliente, estado ou data de entrega;
- actualizar o estado do pedido (por exemplo, de "Em processamento" para "Pronto" e "Entregue").

## 5. Estrutura do repositório

```
bd-lavandaria-nome-apelido/
├── README.md
├── diagrama_er.png
├── modelo_relacional.md
├── 01_criacao_e_insercao.sql
└── 02_manipulacao.sql
```

| Ficheiro | O que contém |
|---|---|
| `01_criacao_e_insercao.sql` | Cria a base de dados `lavanderia`, todas as tabelas com tipos e restrições, e insere pelo menos 20 registos em cada tabela. |
| `02_manipulacao.sql` | 3 `SELECT` simples, 2 `SELECT` com `JOIN`, 2 `UPDATE`, 1 `DELETE` e 1 teste de integridade. Em cada comando escrevi o resultado esperado. |

## 6. Como executar

1. Instale o MySQL (ou o XAMPP, com phpMyAdmin).
2. Execute `01_criacao_e_insercao.sql` para criar a base de dados e inserir os registos.
3. Execute `02_manipulacao.sql` para correr as consultas e as alterações.

O primeiro script pode ser executado várias vezes sem erros, porque apaga e recria a base de dados no início.

## 7. Vídeo

No vídeo (8 a 12 com o obtido.

Link: [COLE AQUI O LINK DO YOUTUBE]
