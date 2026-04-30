-- Purpose: Provide an overview of customer master data including identification, classification, sales reps, payment terms, and contact details.
-- Context: Used to review and validate customer master records in Sage X3, especially for reporting, credit, and sales analysis.
-- Inputs:
--   - (none explicit) -> Full customer set from BPCUSTOMER; can be filtered externally if needed.
-- Outputs (examples):
--   - customer_code        -> Customer code (BPCNUM_0).
--   - customer_name        -> Customer name (BPCNAM_0).
--   - tax_id               -> Tax ID / VAT number (EECNUM_0).
--   - customer_category    -> Customer category code (BCGCOD_0).
--   - customer_type_code   -> Customer type code (TSCCOD_0) + description.
--   - business_area_code   -> Business area code (TSCCOD_1) + description.
--   - sales_rep_1 / sales_rep_2 -> Assigned sales representatives.
--   - payment_terms        -> Payment terms code + description.
--   - country, city, address, postal_code, phone, email.
--   - status               -> Active / Inactive.
-- Notes:
--   - Uses ATEXTRA/ATABDIV to translate codes (customer type, business area) into readable descriptions (in Portuguese).
--   - Joins multiple Sage X3 tables: BPCUSTOMER, BPADDRESS, BPARTNER, TABPAYTERM, SALESREP.


SELECT DISTINCT 

BP.BPCNUM_0 as [Cod Cliente], BP.BPCNAM_0 as [Razão Social],P.EECNUM_0 AS [NIPC], BP.BCGCOD_0 as [Cod Categoria], TSCCOD_0 as [Cod Tipo Cliente],
(SELECT DISTINCT (CASE WHEN A.[TEXTE_0]='Tipo Cliente' THEN '' ELSE A.[TEXTE_0] END)
FROM [x3v12].[X].[ATEXTRA] A
	inner join [x3v12].[X].[ATABDIV] C on C.NUMTAB_0=A.IDENT1_0 and C.ENAFLG_0=1 
                                       and A.IDENT2_0= BP.TSCCOD_0 where A.IDENT1_0='30' 
									   and A.[LANGUE_0]='POR' and A.ZONE_0  ='LNGDES') as [Tipo Cliente],

TSCCOD_1 as [Cod Área Negócio], 
(SELECT DISTINCT (CASE WHEN A.[TEXTE_0]='Área Negócio' THEN '' ELSE A.[TEXTE_0] END)
FROM [x3v12].[X].[ATEXTRA] A
	inner join [x3v12].[X].[ATABDIV] C on C.NUMTAB_0=A.IDENT1_0 and C.ENAFLG_0=1 
                                       and A.IDENT2_0= BP.TSCCOD_1 where A.IDENT1_0='31' 
									   and A.[LANGUE_0]='POR' and A.ZONE_0  ='LNGDES') as [Área Negócio],

I.REPNUM_0 as [Cod Rep 1], I.REPNAM_0 as [Representante 1], I2.REPNUM_0 as [Cod Rep 2], I2.REPNAM_0 as [Representante 2],
BP.PTE_0 as [Cod Cond. pagam],SUBSTRING(LANDESSHO_0,5,CHARINDEX('~',LANDESSHO_0,5)-5) as [Cond. pagam],

BP.CREDATTIM_0 as [Data Criação], YSALFCY_0 as [Estab.venda p/defeit], YSTOFCY_0 as [Estab.exp. p/defeito],
CRYNAM_0 as [País], CTY_0 as [Cidade], BPAADDLIG_0 as [Endereço], POSCOD_0 as [CP], TEL_0 as [Tel], TEL_1 as [Tel 1], TEL_2 as [Tel 2], YCMAIL_0 as [Email Circular], WEB_0 as [E-mail],
BP.YNUMALI_0 AS ALIDATA,
(CASE WHEN BP.BPCSTA_0='1' THEN 'INATIVO'
	  WHEN BP.BPCSTA_0='2' THEN 'ATIVO' END) AS Estado

FROM x3v12.PORTAX1.BPCUSTOMER as BP
INNER JOIN [x3v12].X.BPADDRESS A ON (A.BPANUM_0=BP.BPCNUM_0 AND A.BPAADDFLG_0=2)
INNER JOIN [x3v12].X.BPARTNER P ON (P.BPRNUM_0=BP.BPCNUM_0)
INNER JOIN [x3v12].X.TABPAYTERM T ON (T.PTE_0=BP.PTE_0)

LEFT JOIN(
SELECT REPNAM_0 , REPNUM_0
FROM x3v12.X.SALESREP as SP
LEFT JOIN x3v12.X.BPCUSTOMER as BP on SP.REPNUM_0=BP.REP_0
) AS I ON I.REPNUM_0=BP.REP_0

LEFT JOIN(
SELECT REPNAM_0 , REPNUM_0
FROM x3v12.X.SALESREP as SP
LEFT JOIN x3v12.X.BPCUSTOMER as BP on SP.REPNUM_0=BP.REP_0) AS I2 ON I2.REPNUM_0=BP.REP_1
