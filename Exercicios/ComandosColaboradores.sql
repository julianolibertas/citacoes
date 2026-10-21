-- listar todos os registro de tabela erp...
select * from erp_Coloboradores ec;

/*
Cria uma nova tabela tb_colaboradores baseada 
no erp_Coloboradore, o select copia todos os dados
*/
create table tb_colaboradores as
select * from erp_Coloboradores;
-- lista todos os registros tb_colaboradores
select * from tb_colaboradores tc;
-- selecione ID_empresa agrupando o registros repetidos
select distinct tc.ID_Empresa from tb_colaboradores tc;
-- Lista ID_empresa agrupado e conta quantos registros
select tc.ID_Empresa, count(*) qtde_funcionarios 
from tb_colaboradores tc group by tc.ID_Empresa ;
-- Converte o campo admissao que varchar para data 
ALTER TABLE tb_colaboradores MODIFY COLUMN admissao 
DATE DEFAULT NULL NULL;

-- verifica se campo demissao tem campos vazios ou NULL
select demissao from tb_colaboradores tc ORDER BY 1; 

-- remove os registro NULL do campo demissao.
UPDATE tb_colaboradores tc set demissao = NULL 
WHERE demissao = 'NULL';

-- Converte o campo demissao que é varchar para data 
ALTER TABLE tb_colaboradores MODIFY COLUMN demissao 
DATE DEFAULT NULL NULL;
-- Converte o campo Venc_ferias que é varchar para data 
ALTER TABLE tb_colaboradores MODIFY COLUMN Venc_ferias 
DATE DEFAULT NULL NULL;
-- Converte o campo Nascimento que é varchar para data 
ALTER TABLE tb_colaboradores MODIFY COLUMN Nascimento 
DATE DEFAULT NULL NULL;

select * from tb_colaboradores tc;
select distinct status from tb_colaboradores tc;
select status, count(*) FROM tb_colaboradores tc 
group by status;
select sexo, count(*) FROM tb_colaboradores tc 
where status = 'A' 
group by sexo;
select tc.ID_Est_Civil , count(*) FROM tb_colaboradores tc 
group by tc.ID_Est_Civil ;

select distinct tc.Deficiente, tc.Aposentado 
from tb_colaboradores tc;

select tc.Deficiente , count(*) FROM tb_colaboradores tc 
group by tc.Deficiente ;
select * FROM tb_colaboradores tc 
where tc.Deficiente = 1 ;
-- Criar a tabela tb_estados agrupando a UF e estados
create table tb_estados as
select tc.UF, tc.Estado FROM tb_colaboradores tc
group by tc.UF, tc.Estado;
-- listar a tabela tb_estados
select * from tb_estados;

-- listar tb_colaboradores os salarios dos ativos.
select tc.Salario, count(*) qtde from tb_colaboradores tc
where tc.Status = 'A' group by tc.Salario order by 1 desc;
select sum(tc.Salario) qtde from tb_colaboradores tc
where tc.Status = 'A'  order by 1 desc;

-- calcula a idade dos colaboradores
select tc.Colaborador, tc.Nascimento, 
TIMESTAMPDIFF(YEAR, tc.Nascimento, CURDATE()) 
from tb_colaboradores tc where tc.Status = 'A';
)
-- calcula tempo de serviço dos colaboradores
select tc.Colaborador, 
DATE_FORMAT(tc.admissao,'%d/%m/%Y'), 
DATE_FORMAT(tc.demissao,'%d/%m/%Y'), 
TIMESTAMPDIFF(YEAR, tc.admissao, tc.demissao) 
from tb_colaboradores tc where tc.Status = 'I';
-- -------------------------
SELECT * from tb_colaboradores tc where tc.Colaborador = 'Samuel Correia';

-- cria um index da table colaboradores (colaborador)
CREATE index idx_Colaborador on 
		tb_colaboradores(Colaborador); 
-- apaga o index criado.
drop index idx_Colaborador on tb_colaboradores;

-- Consulta fazendo like.
select * from tb_colaboradores tc 
	where tc.Colaborador like 'Maria%'; 

-- Cria uma fulltext 
create FULLTEXT index search_idx 
		on tb_colaboradores(Colaborador, Endereco);

select tc.Colaborador, tc.Endereco, tc.Cidade, tc.Estado,
tc.CEP, tc.sexo from tb_colaboradores tc
where MATCH(tc.Colaborador, tc.Endereco)
AGAINST('Ana Maria Barbosa');

















