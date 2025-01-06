-----------
WITH TABELACUSTO(c_pro,preco1,preco2,preco3,preco4,preco5) as 
(Select c_pro, -- incluido comentario
isnull((Select top 1 ec_mat.preco_m from ec_mat 
inner join ec_notc on ec_notc.c_enotc = ec_mat.c_enotc 
inner join ntop on ntop.c_ntop = ec_notc.c_ntop 
where ec_mat.c_pro = pro.c_pro and ec_mat.preco_m > 0  and ec_notc.para = 'Fornecedor' and ec_notc.liberado = 1 and ntop.financeiro = 1 
order by ec_notc.demi desc),0) as preco_1, -- Preço 1
-- corte = 1
-----------
isnull((Select top 1 convert(numeric(13,2),(ec_mat.V_Total - ec_mat.vicms) /ec_mat.e_quant) from ec_mat 
inner join ec_notc on ec_notc.c_enotc = ec_mat.c_enotc 
inner join ntop on ntop.c_ntop = ec_notc.c_ntop 
where ec_mat.c_pro = pro.c_pro and ec_notc.c_ntop <> '00011' and ec_notc.stat = '100' and ec_mat.e_quant > 0 and ec_mat.preco_m = 0  and ec_notc.para = 'Fornecedor' and ec_notc.liberado = 1 and ntop.financeiro = 1 
order by ec_notc.demi desc),0) as preco_2, -- Preço 2 
-- 
-----------
isnull((Select top 1 convert(numeric(13,2),(ec_mat.V_Total - ec_mat.vicms) / 
(select sum(ec_des.medida * ec_des.quant) from ec_des where ec_des.c_enotc = ec_mat.c_enotc and ec_des.c_emat = ec_mat.c_emat ) 
) from ec_mat 
inner join ec_notc on ec_notc.c_enotc = ec_mat.c_enotc 
inner join ntop on ntop.c_ntop = ec_notc.c_ntop 
where ec_mat.c_pro = pro.c_pro and ec_notc.c_ntop <> '00011' and ec_notc.stat = '100' and ec_mat.e_quant > 0 and ec_mat.preco_m = 0  and ec_notc.para = 'Fornecedor' and ec_notc.liberado = 1 and ntop.financeiro = 1 
order by ec_notc.demi desc),0) as preco_3, -- Preço 3 
----------
isnull((Select top 1 
CASE WHEN PRO.CORTE = 1 
THEN 
(Select top 1 round(kardex.preco*0.82,2) from kardex where kardex.c_prog = notc.c_prog and kardex.c_pro = inv.c_pro and kardex.nota = notc.nota and kardex.largura = inv.medida)   
ELSE 
round(inv.preco*(0.82),2) 
END 
from notc  
inner join inv on inv.c_prog = notc.c_prog 
inner join ntop on ntop.c_ntop = notc.c_ntop 
where inv.c_pro = pro.c_pro and notc.tipo = 'N' and ntop.financeiro = 1 and notc.conf=1 
order by notc.demi desc),0) as preco_4, -- Preço 4 
------------
isnull(pro.custo,0) as preco_5 -- Preço 5
------------
from pro 
where exists 
(select c_pro from e_Mat 
inner join e_notv on e_notv.c_enotv = e_mat.c_enotv 
inner join ntop on ntop.c_ntop = e_notv.c_ntop 
where e_notv.demi >= ?mdata1 and e_notv.demi <= ?mdata2 and financeiro = 1 and conf = 1 and stat = '100' and e_mat.c_pro = pro.c_pro) 
)
