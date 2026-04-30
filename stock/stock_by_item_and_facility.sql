-- Purpose: Get total stock by item and facility (site), filtered by a list of items and sites.
-- Context: Used to quickly check available stock levels for specific items at selected facilities.
-- Inputs:
--   - :item_list      -> List of item codes (ITMREF_0).
--   - :site_list      -> List of sites/facilities (STOFCY_0).
-- Outputs:
--   - item_code       -> Item code.
--   - stock_qty       -> Total stock quantity (Sage X3 stock unit).
-- Notes:
--   - Considers only stock with STA_0 = 'A' (active / available).
--   - Based on the Sage X3 stock table (x3v12.X.STOCK).


SELECT
    ITMREF_0      AS item_code,
    SUM(QTYSTU_0) AS stock_qty
FROM x3v12.X.STOCK
WHERE ITMREF_0 IN (-- :item_list --)
  AND STOFCY_0 IN (-- :site_list --)
  AND STA_0 = 'A'
GROUP BY ITMREF_0;
