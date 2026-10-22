
-- Trabalho II - Tecnologias de Base de Dados

DROP DATABASE IF EXISTS lavanderia;
CREATE DATABASE lavanderia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lavanderia;

-- ---------------------------------------------------------------------
-- 1. CRIAÇÃO DAS TABELAS (ordem: primeiro as tabelas "pai")
-- ---------------------------------------------------------------------

CREATE TABLE utilizador (
    id_utilizador INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(80)  NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    palavra_passe VARCHAR(64)  NOT NULL,            -- hash SHA-256
    perfil        ENUM('admin','funcionario') NOT NULL DEFAULT 'funcionario'
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(80)  NOT NULL,
    telefone   VARCHAR(15)  NOT NULL UNIQUE,
    endereco   VARCHAR(120) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE servico (
    id_servico     INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(60)  NOT NULL UNIQUE,
    descricao      VARCHAR(150),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0)   -- em MT
) ENGINE=InnoDB;

CREATE TABLE tipo_peca (
    id_tipo_peca INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE maquina (
    id_maquina    INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(60) NOT NULL UNIQUE,
    tipo          ENUM('lavar','secar','passar','lavar_a_seco') NOT NULL,
    capacidade_kg DECIMAL(5,1) NOT NULL CHECK (capacidade_kg > 0),
    estado        ENUM('disponivel','em_uso','avariada') NOT NULL DEFAULT 'disponivel'
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id_pedido             INT AUTO_INCREMENT PRIMARY KEY,
    data_recepcao         DATE NOT NULL,
    data_entrega_prevista DATE NOT NULL,
    estado                ENUM('Recebido','Em processamento','Pronto','Entregue') NOT NULL DEFAULT 'Recebido',
    total                 DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    id_cliente            INT NOT NULL,
    id_utilizador         INT NOT NULL,
    CONSTRAINT chk_datas CHECK (data_entrega_prevista >= data_recepcao),
    CONSTRAINT fk_pedido_cliente    FOREIGN KEY (id_cliente)    REFERENCES cliente(id_cliente),
    CONSTRAINT fk_pedido_utilizador FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador)
) ENGINE=InnoDB;

-- ENTIDADE FRACA: o item só existe dentro de um pedido (chave composta)
CREATE TABLE item_pedido (
    id_pedido    INT NOT NULL,
    nr_item      INT NOT NULL,
    quantidade   INT NOT NULL CHECK (quantidade > 0),
    observacoes  VARCHAR(150),
    id_servico   INT NOT NULL,
    id_tipo_peca INT NOT NULL,
    PRIMARY KEY (id_pedido, nr_item),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido)    REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    CONSTRAINT fk_item_servico FOREIGN KEY (id_servico)  REFERENCES servico(id_servico),
    CONSTRAINT fk_item_tipo    FOREIGN KEY (id_tipo_peca) REFERENCES tipo_peca(id_tipo_peca)
) ENGINE=InnoDB;

CREATE TABLE pagamento (
    id_pagamento   INT AUTO_INCREMENT PRIMARY KEY,
    valor          DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_pagamento DATE NOT NULL,
    metodo         ENUM('Dinheiro','M-Pesa','e-Mola') NOT NULL,
    id_pedido      INT NOT NULL,
    CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
) ENGINE=InnoDB;

CREATE TABLE processamento (
    id_processamento INT AUTO_INCREMENT PRIMARY KEY,
    data_inicio      DATETIME NOT NULL,
    data_fim         DATETIME NULL,
    id_pedido        INT NOT NULL,
    id_maquina       INT NOT NULL,
    CONSTRAINT fk_proc_pedido  FOREIGN KEY (id_pedido)  REFERENCES pedido(id_pedido),
    CONSTRAINT fk_proc_maquina FOREIGN KEY (id_maquina) REFERENCES maquina(id_maquina)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. INSERÇÃO DE REGISTOS (ordem imposta pelas chaves estrangeiras)
-- ---------------------------------------------------------------------

-- 2.1 utilizador (20) - senha de demonstração: Admin@123 / Func@123
INSERT INTO utilizador (id_utilizador, nome, email, palavra_passe, perfil) VALUES
(1,'Reginalda Randinho','reginalda@lavanderia.co.mz',SHA2('Admin@123',256),'admin'),
(2,'Américo Sumbane','americo@lavanderia.co.mz',SHA2('Admin@123',256),'admin'),
(3,'Beatriz Langa','beatriz@lavanderia.co.mz',SHA2('Admin@123',256),'admin'),
(4,'Joana Matsinhe','joana@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(5,'Silvano Cuna','silvano@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(6,'Rosa Tivane','rosa@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(7,'Adelino Mucavele','adelino@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(8,'Nádia Ussene','nadia@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(9,'Gilberto Nhampossa','gilberto@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(10,'Lurdes Macuácua','lurdes@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(11,'Tomé Bambo','tome@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(12,'Alzira Chivambo','alzira@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(13,'Cândido Mavie','candido@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(14,'Dulce Quive','dulce@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(15,'Ernesto Massingue','ernesto@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(16,'Filomena Guambe','filomena@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(17,'Henrique Cossa','henrique@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(18,'Iolanda Mussagy','iolanda@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(19,'Jacinto Nhamitambo','jacinto@lavanderia.co.mz',SHA2('Func@123',256),'funcionario'),
(20,'Lídia Chuquela','lidia@lavanderia.co.mz',SHA2('Func@123',256),'funcionario');

-- 2.2 cliente (20)
INSERT INTO cliente (id_cliente, nome, telefone, endereco) VALUES
(1,'Maria Fernanda Sitoe','841234501','Bairro Macúti, Beira'),
(2,'João Pedro Machava','842345602','Bairro da Munhava, Beira'),
(3,'Ana Paula Chissano','843456703','Bairro Ponta-Gêa, Beira'),
(4,'Carlos Alberto Mondlane','845567804','Bairro da Manga, Beira'),
(5,'Teresa Isabel Nhantumbo','846678905','Bairro do Esturro, Beira'),
(6,'Fátima Domingos Cossa','847789006','Bairro Macúti, Beira'),
(7,'Armando José Tembe','848890107','Bairro Chaimite, Beira'),
(8,'Luísa Manuel Bila','849901208','Bairro Matacuane, Beira'),
(9,'Eduardo Samuel Mabunda','821012309','Bairro Inhamízua, Beira'),
(10,'Sónia Rita Macamo','822123410','Bairro do Estoril, Beira'),
(11,'Rogério Tomás Nhamussua','823234511','Bairro Macúti, Beira'),
(12,'Graça Celeste Muchanga','824345612','Bairro das Palmeiras, Beira'),
(13,'Paulo Jorge Zimba','825456713','Bairro Chipangara, Beira'),
(14,'Helena Joaquim Uamusse','826567814','Bairro Maquinino, Beira'),
(15,'Bernardo Filipe Mucavele','827678915','Bairro Vaz, Beira'),
(16,'Celeste Abel Nhaca','828789016','Bairro Mascarenhas, Beira'),
(17,'Domingos Elias Cumbe','829890117','Bairro Alto da Manga, Beira'),
(18,'Esperança Rui Macie','861901218','Bairro do Goto, Beira'),
(19,'Isaura Daniel Zandamela','862012319','Bairro da Chota, Beira'),
(20,'Faustino Pedro Magaia','863123420','Bairro Nhaconjo, Beira');

-- 2.3 servico (20) - preços em meticais (MT)
INSERT INTO servico (id_servico, nome, descricao, preco_unitario) VALUES
(1,'Lavagem simples','Lavagem normal à máquina',50.00),
(2,'Lavagem e secagem','Lavagem e secagem à máquina',70.00),
(3,'Passar a ferro','Passagem a ferro por peça',30.00),
(4,'Lavagem a seco','Limpeza a seco para peças delicadas',150.00),
(5,'Lavagem de edredão','Lavagem de edredões e mantas grossas',250.00),
(6,'Lavagem de cortinas','Lavagem e secagem de cortinas',200.00),
(7,'Engomagem','Aplicação de goma e passagem',40.00),
(8,'Remoção de manchas','Tratamento especial de manchas difíceis',60.00),
(9,'Lavagem de tapetes','Lavagem de tapetes grandes',300.00),
(10,'Lavagem de fato','Lavagem e passagem de fato completo',180.00),
(11,'Lavagem de vestido','Lavagem de vestidos de festa',120.00),
(12,'Lavagem de uniforme','Uniformes escolares e de trabalho',60.00),
(13,'Lavagem de lençóis','Lavagem de lençóis e fronhas',80.00),
(14,'Lavagem de toalhas','Lavagem de toalhas de banho',45.00),
(15,'Lavagem de cobertor','Lavagem de cobertores',220.00),
(16,'Lavagem de sapatilhas','Limpeza de calçado desportivo',130.00),
(17,'Lavagem delicada','Lavagem manual de peças delicadas',90.00),
(18,'Tingimento','Retoque de cor em peças',160.00),
(19,'Pequenos arranjos','Costuras e botões',100.00),
(20,'Serviço expresso','Entrega no próprio dia',200.00);

-- 2.4 tipo_peca (20)
INSERT INTO tipo_peca (id_tipo_peca, nome) VALUES
(1,'Camisa'),(2,'Calça'),(3,'Vestido'),(4,'Fato'),(5,'Lençol'),
(6,'Toalha'),(7,'Edredão'),(8,'Cortina'),(9,'Tapete'),(10,'Cobertor'),
(11,'Uniforme escolar'),(12,'Camisola'),(13,'Casaco'),(14,'Saia'),(15,'Sapatilhas'),
(16,'Capulana'),(17,'Fronha'),(18,'Roupa interior'),(19,'Gravata'),(20,'Fato de treino');

-- 2.5 maquina (20)
INSERT INTO maquina (id_maquina, nome, tipo, capacidade_kg, estado) VALUES
(1,'Lavadora 1','lavar',10.0,'disponivel'),
(2,'Lavadora 2','lavar',10.0,'em_uso'),
(3,'Lavadora 3','lavar',15.0,'disponivel'),
(4,'Lavadora 4','lavar',15.0,'disponivel'),
(5,'Lavadora 5','lavar',20.0,'disponivel'),
(6,'Lavadora 6','lavar',20.0,'disponivel'),
(7,'Secadora 1','secar',10.0,'disponivel'),
(8,'Secadora 2','secar',10.0,'disponivel'),
(9,'Secadora 3','secar',15.0,'disponivel'),
(10,'Secadora 4','secar',15.0,'avariada'),
(11,'Secadora 5','secar',20.0,'em_uso'),
(12,'Secadora 6','secar',20.0,'disponivel'),
(13,'Ferro industrial 1','passar',5.0,'disponivel'),
(14,'Ferro industrial 2','passar',5.0,'disponivel'),
(15,'Prensa de vapor 1','passar',8.0,'disponivel'),
(16,'Prensa de vapor 2','passar',8.0,'disponivel'),
(17,'Lavagem a seco 1','lavar_a_seco',12.0,'disponivel'),
(18,'Lavagem a seco 2','lavar_a_seco',12.0,'disponivel'),
(19,'Lavadora de tapetes','lavar',25.0,'disponivel'),
(20,'Lavadora 7','lavar',12.0,'avariada');

-- 2.6 pedido (20)
INSERT INTO pedido (id_pedido, data_recepcao, data_entrega_prevista, estado, total, id_cliente, id_utilizador) VALUES
(1,'2026-10-01','2026-10-03','Entregue',440.00,1,4),
(2,'2026-10-02','2026-10-04','Entregue',300.00,2,5),
(3,'2026-10-03','2026-10-06','Entregue',410.00,3,4),
(4,'2026-10-05','2026-10-07','Entregue',240.00,4,6),
(5,'2026-10-06','2026-10-08','Entregue',270.00,5,5),
(6,'2026-10-07','2026-10-10','Entregue',300.00,6,7),
(7,'2026-10-08','2026-10-10','Entregue',300.00,7,4),
(8,'2026-10-10','2026-10-12','Entregue',240.00,8,6),
(9,'2026-10-11','2026-10-14','Entregue',400.00,9,7),
(10,'2026-10-12','2026-10-14','Entregue',500.00,10,5),
(11,'2026-10-13','2026-10-16','Entregue',220.00,11,4),
(12,'2026-10-14','2026-10-16','Entregue',260.00,12,8),
(13,'2026-10-15','2026-10-17','Entregue',270.00,13,6),
(14,'2026-10-16','2026-10-18','Entregue',410.00,1,7),
(15,'2026-10-17','2026-10-19','Entregue',280.00,3,5),
(16,'2026-10-18','2026-10-19','Entregue',350.00,6,8),
(17,'2026-10-19','2026-10-22','Pronto',480.00,2,4),
(18,'2026-10-20','2026-10-22','Pronto',200.00,14,6),
(19,'2026-10-21','2026-10-23','Em processamento',240.00,15,7),
(20,'2026-10-21','2026-10-24','Em processamento',560.00,16,5);

-- 2.7 item_pedido (28) - entidade fraca
INSERT INTO item_pedido (id_pedido, nr_item, quantidade, observacoes, id_servico, id_tipo_peca) VALUES
(1,1,5,'Camisas brancas',2,1),
(1,2,3,NULL,3,2),
(2,1,2,NULL,4,4),
(3,1,1,'Cuidado com as cores',5,7),
(3,2,2,NULL,13,5),
(4,1,4,NULL,12,11),
(5,1,6,NULL,14,6),
(6,1,1,'Tapete da sala',9,9),
(7,1,2,NULL,11,3),
(7,2,2,'Passar a ferro',3,3),
(8,1,1,NULL,10,4),
(8,2,1,'Mancha de vinho',8,1),
(9,1,2,NULL,6,8),
(10,1,10,'Roupa do mês',1,18),
(11,1,1,NULL,15,10),
(12,1,2,NULL,16,15),
(13,1,3,NULL,17,12),
(14,1,5,NULL,1,17),
(14,2,2,NULL,13,5),
(15,1,4,NULL,7,1),
(15,2,4,NULL,3,1),
(16,1,1,'Entrega urgente',20,13),
(16,2,1,NULL,4,13),
(17,1,3,'Cor azul',18,16),
(18,1,2,'Fazer bainha',19,14),
(19,1,3,NULL,12,20),
(19,2,2,NULL,3,19),
(20,1,8,'Roupa de hotel',2,2);

-- 2.8 pagamento (23)
INSERT INTO pagamento (id_pagamento, valor, data_pagamento, metodo, id_pedido) VALUES
(1,200.00,'2026-10-01','Dinheiro',1),
(2,240.00,'2026-10-03','M-Pesa',1),
(3,300.00,'2026-10-04','Dinheiro',2),
(4,410.00,'2026-10-06','M-Pesa',3),
(5,240.00,'2026-10-07','e-Mola',4),
(6,150.00,'2026-10-06','Dinheiro',5),
(7,120.00,'2026-10-08','Dinheiro',5),
(8,300.00,'2026-10-10','M-Pesa',6),
(9,300.00,'2026-10-10','Dinheiro',7),
(10,240.00,'2026-10-12','e-Mola',8),
(11,400.00,'2026-10-14','M-Pesa',9),
(12,250.00,'2026-10-12','Dinheiro',10),
(13,250.00,'2026-10-14','Dinheiro',10),
(14,220.00,'2026-10-16','e-Mola',11),
(15,260.00,'2026-10-16','Dinheiro',12),
(16,270.00,'2026-10-17','M-Pesa',13),
(17,200.00,'2026-10-16','Dinheiro',14),
(18,210.00,'2026-10-18','Dinheiro',14),
(19,280.00,'2026-10-19','e-Mola',15),
(20,350.00,'2026-10-19','M-Pesa',16),
(21,240.00,'2026-10-19','Dinheiro',17),
(22,200.00,'2026-10-20','M-Pesa',18),
(23,300.00,'2026-10-21','Dinheiro',20);

-- 2.9 processamento (22)
INSERT INTO processamento (id_processamento, data_inicio, data_fim, id_pedido, id_maquina) VALUES
(1,'2026-10-01 09:00','2026-10-01 10:00',1,1),
(2,'2026-10-01 10:15','2026-10-01 11:15',1,7),
(3,'2026-10-02 08:30','2026-10-02 10:30',2,17),
(4,'2026-10-03 09:00','2026-10-03 10:00',3,3),
(5,'2026-10-03 10:15','2026-10-03 11:30',3,9),
(6,'2026-10-05 08:00','2026-10-05 09:00',4,2),
(7,'2026-10-06 09:30','2026-10-06 10:30',5,4),
(8,'2026-10-07 08:00','2026-10-07 11:00',6,19),
(9,'2026-10-08 09:00','2026-10-08 10:00',7,5),
(10,'2026-10-10 10:00','2026-10-10 12:00',8,18),
(11,'2026-10-11 08:30','2026-10-11 09:45',9,6),
(12,'2026-10-12 09:00','2026-10-12 10:00',10,1),
(13,'2026-10-13 09:00','2026-10-13 10:30',11,5),
(14,'2026-10-14 09:00','2026-10-14 10:00',12,3),
(15,'2026-10-15 08:30','2026-10-15 09:30',13,2),
(16,'2026-10-16 09:00','2026-10-16 10:00',14,4),
(17,'2026-10-17 10:00','2026-10-17 11:00',15,13),
(18,'2026-10-18 09:00','2026-10-18 10:00',16,15),
(19,'2026-10-19 09:00','2026-10-19 10:30',17,6),
(20,'2026-10-20 11:00','2026-10-20 12:00',18,14),
(21,'2026-10-21 09:00',NULL,19,2),
(22,'2026-10-21 10:00',NULL,20,11);

-- Verificação rápida: nº de registos por tabela
SELECT 'utilizador' AS tabela, COUNT(*) AS registos FROM utilizador UNION ALL
SELECT 'cliente', COUNT(*) FROM cliente UNION ALL
SELECT 'servico', COUNT(*) FROM servico UNION ALL
SELECT 'tipo_peca', COUNT(*) FROM tipo_peca UNION ALL
SELECT 'maquina', COUNT(*) FROM maquina UNION ALL
SELECT 'pedido', COUNT(*) FROM pedido UNION ALL
SELECT 'item_pedido', COUNT(*) FROM item_pedido UNION ALL
SELECT 'pagamento', COUNT(*) FROM pagamento UNION ALL
SELECT 'processamento', COUNT(*) FROM processamento;
