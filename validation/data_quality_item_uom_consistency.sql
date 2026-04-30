-- Purpose: Identify items where stock quantities are not whole numbers after applying the unit conversion factor.
-- Context: Used to detect potential unit of measure (UoM) configuration issues for items at a given facility.
-- Inputs:
--   - :facility_code -> Site/facility code (STOFCY_0).
-- Outputs:
--   - item_code      -> Item code (ITMREF_0).
--   - converted_qty  -> Stock quantity converted by PUUSTUCOE_0.
-- Notes:
--   - Flags items where the converted quantity is not an integer (converted_qty <> FLOOR(converted_qty)).
--   - Based on stock and item master data in Sage X3.

SELECT
    STOCK.ITMREF_0                                  AS item_code,
    SUM(QTYSTU_0 / PUUSTUCOE_0)                     AS converted_qty
FROM x3v12.X.STOCK
INNER JOIN x3v12.X.ITMMASTER
    ON ITMMASTER.ITMREF_0 = STOCK.ITMREF_0
WHERE STOFCY_0 = -- :facility_code --
GROUP BY
    STOCK.ITMREF_0
HAVING SUM(QTYSTU_0 / PUUSTUCOE_0)
       <> FLOOR(SUM(QTYSTU_0 / PUUSTUCOE_0));
