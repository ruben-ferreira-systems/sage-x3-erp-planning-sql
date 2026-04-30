-- Purpose: Summarise miscellaneous stock receipts and issues by date, site, item, and document type.
-- Context: Used to monitor manual stock adjustments (miscellaneous receipts/issues) over time and by item,
--          for auditing and process improvement.
-- Inputs:
--   - :facility_code -> Site/facility code (STOFCY_0).
--   - (optional) date range can be applied externally on CREDAT_0 if needed.
-- Outputs:
--   - movement_date   -> Posting date (CREDAT_0) formatted as DD-MM-YYYY.
--   - site_code       -> Site/facility (STOFCY_0).
--   - item_code       -> Item code (ITMREF_0).
--   - item_description-> Item description (YITMDES_0).
--   - quantity        -> Net quantity in stock unit (QTYPCU_0).
--   - doc_type_label  -> 'EntradaDiversa', 'SaídaDiversa', or 'Outro' based on VCRTYP_0.
-- Notes:
--   - Includes only VCRTYP_0 IN ('19','20'), which typically correspond to miscellaneous receipts/issues.
--   - Based on STOJOU (stock journal) and ITMMASTER (item master).

SELECT
    CONVERT(VARCHAR, S.CREDAT_0, 105) AS movement_date,  -- DD-MM-YYYY
    S.STOFCY_0                        AS site_code,
    S.ITMREF_0                        AS item_code,
    I.YITMDES_0                       AS item_description,
    SUM(S.QTYPCU_0)                   AS quantity,
    CASE
        WHEN VCRTYP_0 = '19' THEN 'EntradaDiversa'
        WHEN VCRTYP_0 = '20' THEN 'SaídaDiversa'
        ELSE 'Outro'
    END                               AS doc_type_label
FROM x3v12.X.STOJOU S
INNER JOIN x3v12.X.ITMMASTER I
    ON S.ITMREF_0 = I.ITMREF_0
WHERE S.STOFCY_0 = 'E0301'                 -- :facility_code
  AND VCRTYP_0 IN ('19', '20')
GROUP BY
    S.CREDAT_0,
    S.STOFCY_0,
    S.ITMREF_0,
    I.YITMDES_0,
    CASE
        WHEN VCRTYP_0 = '19' THEN 'EntradaDiversa'
        WHEN VCRTYP_0 = '20' THEN 'SaídaDiversa'
        ELSE 'Outro'
    END
ORDER BY
    S.CREDAT_0;
