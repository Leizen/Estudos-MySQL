CREATE DATABASE IF NOT EXISTS vendas_sucos;

USE vendas_sucos;

CREATE TABLE produtos(
CODIGO VARCHAR(10) NOT NULL,
DESCRITOR VARCHAR(100) NULL,
SABOR VARCHAR(50) NULL,
TAMANHO VARCHAR(50) NULL,
EMBALAGEM VARCHAR(50) NULL,
PRECO_LISTA FLOAT NULL,
PRIMARY KEY(CODIGO));

CREATE TABLE vendedores(
MATRICULA VARCHAR(5) NOT NULL,
NOME VARCHAR(100) NULL,
BAIRRO VARCHAR(50) NULL,
COMISSAO FLOAT NULL,
DATA_ADMISSAO DATE,
FERIAS BOOLEAN,
PRIMARY KEY(MATRICULA));

CREATE TABLE clientes(
CPF VARCHAR(11) NOT NULL PRIMARY KEY,
NOME VARCHAR(100) NULL,
ENDERECO VARCHAR(150) NULL,
BAIRRO VARCHAR(50) NULL,
CIDADE VARCHAR(50) NULL,
ESTADO VARCHAR(50) NULL,
CEP VARCHAR(8) NULL,
DATA_NASCIMENTO DATE NULL,
IDADE INT NULL,
SEXO VARCHAR(1) NULL,
LIMITE_CREDITO FLOAT NULL,
VOLUME_COMPRA FLOAT NULL,
PRIMEIRA_COMPRA BOOLEAN NULL);

CREATE TABLE tabela_de_vendas(
NUMERO VARCHAR(5) NOT NULL PRIMARY KEY,
DATA_VENDA DATE NULL,
CPF VARCHAR(11) NOT NULL,
MATRICULA VARCHAR(5) NOT NULL,
IMPOSTO FLOAT NULL);

CREATE TABLE itens_notas(
NUMERO VARCHAR(5) NOT NULL,
CODIGO VARCHAR(10) NOT NULL ,
QUANTIDADE INT,
PRECO FLOAT,
PRIMARY KEY (NUMERO,CODIGO));

/*ADICIONANDO CHAVE ESTRANGEIRA EM UMA TABELA*/
ALTER TABLE tabela_de_vendas ADD CONSTRAINT fk_clientes FOREIGN KEY (CPF) REFERENCES clientes (CPF);
ALTER TABLE tabela_de_vendas ADD CONSTRAINT fk_vendedores FOREIGN KEY (MATRICULA) REFERENCES vendedores (MATRICULA);
ALTER TABLE itens_notas ADD CONSTRAINT fk_notas FOREIGN KEY (NUMERO) REFERENCES notas (NUMERO);
ALTER TABLE itens_notas ADD CONSTRAINT fk_produtos FOREIGN KEY (CODIGO) REFERENCES produtos (CODIGO);

/*ALTERAR NOME DA TABELA*/
ALTER TABLE TABELA_DE_VENDAS RENAME NOTAS;

/*ALTERAR NOME DA COLUNA*/
/*ALTER TABLE VENDEDORES RENAME COLUMN DATA_ADIMISSAO TO DATA_ADMISSAO;*/

/*----------INSERINDO DADOS--------------*/
INSERT INTO produtos (codigo,descritor,sabor,tamanho,embalagem,preco_lista) VALUES ('1040107', 'Light - 350 ml - Melância', 'Melância', '350 ml', 'Lata', 4.56);
INSERT INTO produtos (codigo,descritor,sabor,tamanho,embalagem,preco_lista) VALUES ('1040108', 'Light - 350 ml - Graviola', 'Graviola', '350 ml', 'Lata', 4.00);
INSERT INTO produtos VALUES ('1040109', 'Light - 350 ml - Açai', 'Açai', '350 ml', 'Lata', 5.60);

INSERT INTO produtos VALUES 
('1040110', 'Light - 350 ml - Jaca', 'Jaca', '350 ml', 'Lata', 6.00),
('1040111', 'Light - 350 ml - Manga', 'Manga', '350 ml', 'Lata', 3.50);

SELECT * FROM produtos;

/*----IMPORTANDO DADOS DE OUTRO BANCO MYSQL----*/
USE vendas_sucos;

SELECT codigo_do_produto AS CODIGO, nome_do_produto as DESCRITOR, EMBALAGEM, TAMANHO, SABOR, preco_de_lista AS PRECO_LISTA 
FROM sucos_vendas.tabela_de_produtos
WHERE codigo_do_produto NOT IN (SELECT CODIGO FROM produtos);

INSERT INTO produtos 
SELECT codigo_do_produto AS CODIGO, nome_do_produto as DESCRITOR, SABOR, TAMANHO, EMBALAGEM, preco_de_lista AS PRECO_LISTA 
FROM sucos_vendas.tabela_de_produtos
WHERE codigo_do_produto NOT IN (SELECT CODIGO FROM produtos);

/*---------Os clientes foram inseridos através de um arquivo .csv---------------*/
SELECT * FROM clientes;
         
INSERT INTO vendedores (matricula,nome,comissao,data_admissao,bairro) VALUES 
('235','Márcio Almeida Silva',0.08,'2014-08-15 00:00:00','Tijuca'),
('236','Cláudia Morais',0.08,'2013-09-17 00:00:00','Jardins'),
('237','Roberta Martins',0.11,'2017-03-18 00:00:00','Copacabana'),
('238','Péricles Alves',0,'2016-08-21 00:00:00','Santo Amaro');

/*-----------------------ALTERANDO CAMPOS DENTRO DA TABELA--------------------*/
UPDATE produtos SET preco_lista = 5 WHERE codigo = '1000889';

UPDATE produtos SET embalagem = 'PET', tamanho = '1 Litro', descritor = 'Sabor da Montanha - 1 Litro - Uva' WHERE codigo = '1000889';

UPDATE produtos SET preco_lista = preco_lista * 1.10 WHERE sabor = 'Maracujá';

/*------------------------UPDATE USANDO FROM----------------------------*/
SELECT * FROM vendedores A INNER JOIN sucos_vendas.tabela_de_vendedores B
ON A.matricula = SUBSTRING(B.matricula, 3,3);

UPDATE vendedores A INNER JOIN sucos_vendas.tabela_de_vendedores B
ON A.matricula = SUBSTRING(B.matricula, 3,3)
SET A.ferias = B.de_ferias;

/*---------------EXCLUINDO CONTEUDO DA TABELA-------------*/
/*os produtos que serão excluidos foram inseridos através de outro script*/

SELECT * FROM produtos WHERE SUBSTRING(DESCRITOR,1,15) = 'Sabor dos Alpes';

DELETE FROM produtos WHERE codigo = '1001000';

DELETE FROM produtos WHERE tamanho = '1 Litro' AND SUBSTRING(descritor,1,15) = 'Sabor dos Alpes';

DELETE FROM produtos WHERE
codigo NOT IN (SELECT codigo_do_produto FROM sucos_vendas.tabela_de_produtos);

/*-----------UTILIZANDO COMMIT E ROLLBACK--------------------*/
SELECT * FROM vendedores;

START TRANSACTION;
UPDATE VENDEDORES SET COMISSAO = COMISSAO * 1.15;
ROLLBACK;

START TRANSACTION;
UPDATE VENDEDORES SET COMISSAO = COMISSAO * 1.15;
COMMIT;

START TRANSACTION;
UPDATE VENDEDORES SET COMISSAO = COMISSAO * 1.15;
COMMIT;

/*--------------COMO UTILIZAR TRIGGERS-------------------*/
CREATE TABLE tab_faturamento
(data_venda DATE NULL,
total_venda FLOAT);

SELECT * FROM tab_faturamento;

INSERT INTO notas (numero, data_venda, cpf, matricula, imposto) VALUES ('0102', '2020-12-07', '1471156710', '235', 0.10);
INSERT INTO itens_notas (numero, codigo, quantidade, preco) VALUES ('0102', '1000889', 100, 10);
INSERT INTO notas (numero, data_venda, cpf, matricula, imposto) VALUES ('0102', '2020-12-07', '1471156710', '235', 0.10);
INSERT INTO itens_notas (numero, codigo, quantidade, preco) VALUES ('0102', '1002334', 100, 10);
DELETE FROM tab_faturamento;
INSERT INTO tab_faturamento
SELECT A.data_venda, SUM(B.quantidade * B.preco) AS total_venda FROM
notas A INNER JOIN itens_notas B
ON A.numero = B.numero
GROUP BY A.data-venda;

DELIMITER //
CREATE TRIGGER tg_calcula_faturamento_insert AFTER INSERT ON itens_notas
FOR EACH ROW BEGIN
	DELETE FROM tab_faturamento;
	INSERT INTO tab_faturamento
	SELECT A.data_venda, SUM(B.quantidade * B.preco) AS total_venda FROM
	notas A INNER JOIN itens_notas B
	ON A.numero = B.numero
	GROUP BY A.data-venda;
END//

UPDATE itens_notas SET quantidade = 200
WHERE numero = '0102' AND codigo = '1002334';

DELETE itens_notas SET quantidade = 200
WHERE numero = '0102' AND codigo = '1002334';

DELIMITER //
CREATE TRIGGER tg_calcula_faturamento_update AFTER UPDATE ON itens_notas
FOR EACH ROW BEGIN
	DELETE FROM tab_faturamento;
	INSERT INTO tab_faturamento
	SELECT A.data_venda, SUM(B.quantidade * B.preco) AS total_venda FROM
	notas A INNER JOIN itens_notas B
	ON A.numero = B.numero
	GROUP BY A.data-venda;
END//

DELIMITER //
CREATE TRIGGER tg_calcula_faturamento_delete AFTER DELETE ON itens_notas
FOR EACH ROW BEGIN
	DELETE FROM tab_faturamento;
	INSERT INTO tab_faturamento
	SELECT A.data_venda, SUM(B.quantidade * B.preco) AS total_venda FROM
	notas A INNER JOIN itens_notas B
	ON A.numero = B.numero
	GROUP BY A.data-venda;
END//