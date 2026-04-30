-- Purpose: Retrieve the mapping between internal item codes and supplier item codes and descriptions for a given supplier.
-- Context: Used to validate and work with supplier-specific item codes when integrating purchase data or documents from suppliers.
-- Inputs:
--   - :supplier_code -> Supplier code (BPSNUM_0).
-- Outputs:
--   - item_code          -> Internal item code (ITMREF_0).
--   - supplier_item_code -> Supplier's item code (ITMREFBPS_0).
--   - supplier_item_desc -> Supplier's item description (ITMDESBPS_0).
-- Notes:
--   - Based on the ITMMASTER and ITMBPS tables in Sage X3.

SELECT
    I.ITMREF_0      AS item_code,
    S.ITMREFBPS_0   AS supplier_item_code,
    S.ITMDESBPS_0   AS supplier_item_desc
FROM x3v12.X.ITMMASTER I
LEFT JOIN x3v12.X.ITMBPS S
    ON I.ITMREF_0 = S.ITMREF_0
WHERE S.BPSNUM_0 = %1%;
