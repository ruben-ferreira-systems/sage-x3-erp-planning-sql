-- Purpose: Map customer-specific item codes to internal item codes for a given customer.
-- Context: Used when customers use their own item codes on orders, and those need to be translated into internal item codes.
-- Inputs:
--   - :customer_item_code_list -> List of customer item codes (ITMREFBPC_0).
-- Outputs:
--   - customer_item_code  -> Customer item code (ITMREFBPC_0).
--   - item_code           -> Internal item code (ITMREF_0).
--   - item_description    -> Internal item description.
-- Notes:
--   - Based on ITMBPC (customer-item cross-reference) and ITMMASTER tables.

SELECT *
FROM x3v12.X.ITMBPC AS IC
LEFT JOIN x3v12.X.ITMMASTER AS I
    ON I.ITMREF_0 = IC.ITMREF_0
WHERE ITMREFBPC_0 IN (-- :customer_item_code_list --);
