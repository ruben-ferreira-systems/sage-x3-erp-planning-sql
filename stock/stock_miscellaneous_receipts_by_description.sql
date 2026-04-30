-- Purpose: Analyse miscellaneous stock receipts/issues by description for specific items and sites.
-- Context: Used to review manual stock adjustments (miscellaneous receipts/issues) grouped by description,
--          helping to understand why stock is being adjusted outside normal purchase/production flows.
-- Inputs:
--   - :description_list -> List of movement descriptions (TH.VCRDES_0) to filter on.
-- Outputs:
--   - site_code         -> Site/facility (STOFCY_0).
--   - item_code         -> Item code (ITMREF_0).
--   - quantity          -> Net adjusted quantity (sum of QTYSTU_0).
--   - item_description  -> Item description (ITMDES1_0).
--   - movement_desc     -> Movement description (VCRDES_0).
-- Notes:
--   - Based on STOJOU (stock journal), ITMMASTER (item master) and SMVTH (movement header).
--   - Returns only records where the net quantity is not zero (SUM(QTYSTU_0) <> 0).

SELECT
    STJ.STOFCY_0      AS site_code,
    STJ.ITMREF_0      AS item_code,
    SUM(STJ.QTYSTU_0) AS quantity,
    ITM.ITMDES1_0     AS item_description,
    TH.VCRDES_0       AS movement_desc
FROM x3v12.X.STOJOU STJ
INNER JOIN x3v12.X.ITMMASTER ITM
    ON STJ.ITMREF_0 = ITM.ITMREF_0
LEFT JOIN x3v12.X.SMVTH TH
    ON STJ.VCRNUM_0 = TH.VCRNUM_0
WHERE TH.VCRDES_0 IN (-- :description_list --)
GROUP BY
    STJ.STOFCY_0,
    STJ.ITMREF_0,
    ITM.ITMDES1_0,
    TH.VCRDES_0
HAVING SUM(STJ.QTYSTU_0) <> 0
ORDER BY
    STJ.STOFCY_0,
    STJ.ITMREF_0;
