USE sucos_vendas;

SELECT * FROM tabela_de_clientes;

/*---------------Consultas com condições---------------*/
SELECT * FROM tabela_de_produtos WHERE SABOR = 'Manga' OR TAMANHO = '470 ml';

SELECT * FROM tabela_de_produtos WHERE SABOR = 'Manga' AND TAMANHO = '470 ml';

SELECT * FROM tabela_de_produtos WHERE NOT(SABOR = 'Manga' AND TAMANHO = '470 ml');

SELECT * FROM tabela_de_produtos WHERE NOT(SABOR = 'Manga' OR TAMANHO = '470 ml');

SELECT * FROM tabela_de_produtos WHERE SABOR = 'Manga' AND NOT (TAMANHO = '470 ml');

SELECT * FROM tabela_de_produtos WHERE SABOR IN ('Laranja', 'Manga');

SELECT * FROM tabela_de_clientes WHERE CIDADE IN ('Rio de Janeiro', 'São Paulo') AND IDADE >= 20; 

SELECT * FROM tabela_de_produtos WHERE SABOR LIKE '%Maça%';

SELECT * FROM tabela_de_produtos WHERE SABOR LIKE '%Maça%' AND EMBALAGEM = 'PET';

/*---------DISTINCT retorna somente linhas com valores diferentes-----------------*/
SELECT EMBALAGEM, TAMANHO FROM tabela_de_produtos;
SELECT DISTINCT EMBALAGEM, TAMANHO FROM tabela_de_produtos;
SELECT DISTINCT EMBALAGEM, TAMANHO FROM tabela_de_produtos WHERE SABOR = 'Laranja';

/*---------LIMIT limita o número de linhas exibidas-----------------*/
SELECT * FROM tabela_de_produtos LIMIT 5;
SELECT * FROM tabela_de_produtos LIMIT 2,3;

/*---------ORDER BY ordena o resultado da consulta pelo campo determinado-----------------*/
SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA;
SELECT * FROM tabela_de_produtos ORDER BY PRECO_DE_LISTA DESC;
SELECT * FROM tabela_de_produtos ORDER BY NOME_DO_PRODUTO;
SELECT * FROM tabela_de_produtos ORDER BY NOME_DO_PRODUTO DESC;
SELECT * FROM tabela_de_produtos ORDER BY EMBALAGEM, NOME_DO_PRODUTO;
SELECT * FROM tabela_de_produtos ORDER BY EMBALAGEM DESC, NOME_DO_PRODUTO ASC;

/*---------------agrupar resposta----------------------------*/
SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS LIMITE_TOTAL FROM tabela_de_clientes GROUP BY ESTADO;

SELECT NOME_DO_PRODUTO, EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM;

SELECT BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes WHERE CIDADE = 'Rio de Janeiro' GROUP BY BAIRRO;

SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes GROUP BY ESTADO, BAIRRO;

SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes WHERE CIDADE = 'Rio de Janeiro' GROUP BY ESTADO, BAIRRO;

SELECT ESTADO, BAIRRO, SUM(LIMITE_DE_CREDITO) AS LIMITE FROM tabela_de_clientes WHERE CIDADE = 'Rio de Janeiro' GROUP BY ESTADO, BAIRRO ORDER BY BAIRRO;

/*--------------having condição que se aplica ao resultado de uma agregação----------------------------*/
SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS SOMA_LIMITE FROM tabela_de_clientes GROUP BY ESTADO HAVING SUM(LIMITE_DE_CREDITO) > 900000;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO, MIN(PRECO_DE_LISTA) AS MENOR_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM HAVING SUM(PRECO_DE_LISTA) <= 80;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS MAIOR_PRECO, MIN(PRECO_DE_LISTA) AS MENOR_PRECO FROM tabela_de_produtos GROUP BY EMBALAGEM HAVING SUM(PRECO_DE_LISTA) <= 80 AND MAX(PRECO_DE_LISTA) >=5;

/*--------------CASE realizar teste em um ou mais campos, e dependendo do resultado teremos um outro valor (classificação)----------------------------*/
SELECT NOME_DO_PRODUTO, PRECO_DE_LISTA,
CASE 
	WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	ELSE 'PRODUTO BARATO' 
END AS STATUS_PRECO 
FROM tabela_de_produtos;

SELECT EMBALAGEM,
CASE 
	WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	ELSE 'PRODUTO BARATO' 
END AS STATUS_PRECO, AVG(PRECO_DE_LISTA) AS PRECO_MEDIO FROM tabela_de_produtos GROUP BY EMBALAGEM, 
CASE 
	WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	ELSE 'PRODUTO BARATO' 
END ORDER BY EMBALAGEM;

/*--------------JOINs possibilidade de unir uma ou mais tabelas através de campos em comum----------------------------*/
SELECT * FROM tabela_de_vendedores;
SELECT * FROM notas_fiscais;

/*INNER JOIN*/
SELECT * FROM tabela_de_vendedores A
INNER JOIN notas_fiscais B
ON A.matricula = B.matricula;

SELECT A.MATRICULA, A.NOME, COUNT(*) AS QNT_NOTAS FROM tabela_de_vendedores A INNER JOIN notas_fiscais B
ON A.matricula = B.matricula
GROUP BY A.MATRICULA, A.NOME;

/*LEFT JOIN e RIGHT JOIN*/
SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A INNER JOIN notas_fiscais B 
ON A.CPF = B.CPF;

SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A LEFT JOIN notas_fiscais B ON A.CPF = B.CPF;
SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A LEFT JOIN notas_fiscais B ON A.CPF = B.CPF WHERE B.CPF IS NULL;
SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM tabela_de_clientes A LEFT JOIN notas_fiscais B ON A.CPF = B.CPF WHERE YEAR(B.DATA_VENDA) = 2015;

SELECT DISTINCT A.CPF, A.NOME, B.CPF FROM notas_fiscais B RIGHT JOIN tabela_de_clientes A ON A.CPF = B.CPF WHERE B.CPF IS NULL;

/*FULL e CROSS JOIN*/
SELECT * FROM tabela_de_vendedores;
SELECT * FROM tabela_de_clientes;

SELECT * FROM tabela_de_vendedores INNER JOIN tabela_de_clientes ON tabela_de_vendedores.BAIRRO = tabela_de_clientes.BAIRRO;

SELECT tabela_de_vendedores.BAIRRO, tabela_de_vendedores.NOME, `DE_FERIAS` ,tabela_de_vendedores.DE_FERIAS, tabela_de_clientes.BAIRRO, tabela_de_clientes.NOME 
FROM tabela_de_vendedores INNER JOIN tabela_de_clientes 
ON tabela_de_vendedores.BAIRRO = tabela_de_clientes.BAIRRO;

/*CROSS*/
SELECT tabela_de_vendedores.BAIRRO, tabela_de_vendedores.NOME, `DE_FERIAS` ,tabela_de_vendedores.DE_FERIAS, tabela_de_clientes.BAIRRO, tabela_de_clientes.NOME 
FROM tabela_de_vendedores, tabela_de_clientes ;

/*--------------UNION faz união de duas ou mais tabelas----------------------------*/
SELECT DISTINCT BAIRRO FROM tabela_de_clientes;
SELECT DISTINCT BAIRRO FROM tabela_de_vendedores;

SELECT DISTINCT BAIRRO FROM tabela_de_clientes
UNION
SELECT DISTINCT BAIRRO FROM tabela_de_vendedores;

SELECT DISTINCT BAIRRO FROM tabela_de_clientes
UNION ALL
SELECT DISTINCT BAIRRO FROM tabela_de_vendedores;

SELECT DISTINCT BAIRRO, NOME, 'CLIENTE' AS TIPO FROM tabela_de_clientes
UNION ALL
SELECT DISTINCT BAIRRO, NOME, 'VENDEDOR' AS TIPO FROM tabela_de_vendedores;

/*--------------sub-consultas----------------------------*/
SELECT * FROM tabela_de_clientes WHERE BAIRRO IN ('Tijuca', 'Jardins', 'Copacabana', 'Santo Amaro');
SELECT * FROM tabela_de_clientes WHERE BAIRRO IN (SELECT DISTINCT BAIRRO FROM tabela_de_vendedores);

SELECT X.EMBALAGEM, X.PRECO_MAXIMO FROM
(SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAXIMO FROM tabela_de_produtos GROUP BY EMBALAGEM) X
WHERE X.PRECO_MAXIMO >= 10;

/*--------------VIEW tabela lógica, resultado de uma consulta que pode ser usada depois em outra consulta----------------------------*/
SELECT X.EMBALAGEM, X.MAIOR_PRECO FROM vw_maiores_embalagens X WHERE X.MAIOR_PRECO >= 10;

SELECT A.NOME_DO_PRODUTO, A.EMBALAGEM, A.PRECO_DE_LISTA, X.MAIOR_PRECO FROM tabela_de_produtos A INNER JOIN vw_maiores_embalagens X ON A.EMBALAGEM = X.EMBALAGEM;