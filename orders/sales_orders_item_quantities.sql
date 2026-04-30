-- Purpose: Summarise ordered quantities by item for a given set of sales orders.
-- Context: Used to quickly see total demand per item across one or more sales orders (e.g., for planning or checking large orders).
-- Inputs:
--   - :sales_order_list -> List of sales order numbers (SOHNUM_0).
-- Outputs:
--   - item_code         -> Item code (ITMREF_0).
--   - item_description  -> Item description (YITMDES_0).
--   - quantity          -> Total ordered quantity (QTYSTU_0) cast to INT.
--   - uom_code          -> Unit of measure (STU_0).
-- Notes:
--   - Aggregates SORDERQ lines by item and unit of measure.
--   - Based on SORDERQ and ITMMASTER.

SELECT
    I.ITMREF_0             AS item_code,
    I.YITMDES_0            AS item_description,
    CAST(SUM(QTYSTU_0) AS INT) AS quantity,
    I.STU_0                AS uom_code
FROM x3v12.X.SORDERQ AS S
LEFT JOIN x3v12.X.ITMMASTER AS I
    ON I.ITMREF_0 = S.ITMREF_0
WHERE S.SOHNUM_0 IN (-- :sales_order_list --)
GROUP BY
    I.ITMREF_0,
    I.YITMDES_0,
    I.STU_0;
