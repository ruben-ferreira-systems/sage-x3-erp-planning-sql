-- Purpose: Extract delivery note observations (free text) from sales deliveries, converting RTF content into plain text.
-- Context: Used to review remarks entered on delivery notes, for example to analyse common customer or supplier comments.
-- Inputs:
--   - (none explicit) -> All deliveries with non-empty text; can be filtered externally by date, customer, etc.
-- Outputs:
--   - delivery_number    -> Delivery note number (SDHNUM_0).
--   - sales_order_number -> Sales order number (SOHNUM_0).
--   - supplier_id        -> Supplier / business partner code (BPCORD_0).
--   - supplier_name      -> Supplier / business partner name (BPDNAM_0).
--   - delivery_date      -> Delivery date (SHIDAT_0).
--   - text_plain         -> Delivery text/observations converted from RTF to plain text.
-- Notes:
--   - Uses the Sage X3 function RTF2Text to convert TEXCLOB RTF content into VARCHAR.
--   - Returns only records where the converted text is not NULL.

SELECT
    S.SDHNUM_0                                                    AS delivery_number,
    S.SOHNUM_0                                                    AS sales_order_number,
    S.BPCORD_0                                                    AS supplier_id,
    S.BPDNAM_0                                                    AS supplier_name,
    S.SHIDAT_0                                                    AS delivery_date,
    CAST(x3v12.X.RTF2Text(T.TEXTE_0) AS VARCHAR(200))             AS text_plain
FROM x3v12.X.SDELIVERY S
LEFT JOIN x3v12.X.TEXCLOB T
    ON T.CODE_0 = S.PRPTEX1_0
WHERE x3v12.X.RTF2Text(T.TEXTE_0) IS NOT NULL;
