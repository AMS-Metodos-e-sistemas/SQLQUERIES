-- Clientes com a situação de credito liberado e que não possui compras depois de 2020
select c_cli,nome,cresitua from cli
where c_cli not in (Select cli.c_cli from cli
inner join e_cli on e_cli.c_cli = cli.c_cli
inner join e_notv on e_notv.c_enotv = e_cli.c_enotv
where year(e_notv.demi) > 2020
group by cli.c_cli) and UPPER(LEFT(cli.cresitua,1)) = 'L' 

-- Preciso que baixe o credito para A Vista, dos clientes que estão como credito “liberados”
-- e não compram desde 31/12/2020 para traz.

--Limite de Credito== 0,00
--Situação do Credito== A Vista
--Inf. de Crédito== 31/12/2020
--Forma de Pagamento== A Vista

-- cli.info_cre -> 31/12/2020
-- cli.crelimite -> 0
-- cli.cresitua -> 'A Vista'
-- cli.c_pgto -> 00001

-- Comando
--update cli set cli.info_cre = '31/12/2020', cli.crelimite = 0, cli.cresitua = 'A Vista',cli.c_pgto = '00001'
--where c_cli in (select c_cli from cli
--where c_cli not in (Select cli.c_cli from cli
--inner join e_cli on e_cli.c_cli = cli.c_cli
--inner join e_notv on e_notv.c_enotv = e_cli.c_enotv
--where year(e_notv.demi) > 2020
--group by cli.c_cli) and UPPER(LEFT(cli.cresitua,1)) = 'L')