-- Purpose: List sales orders for a given customer and facility that have allocated quantities.
-- Context: Used by planners and customer service to identify sales orders already reserved/allocated against stock or production.
-- Inputs:
--   - :customer_code -> Customer code (O.BPCINV_0).
--   - :facility_code -> Sales facility/site (O.SALFCY_0).
-- Outputs:
--   - sales_order_number -> Sales order number (SOHNUM_0).
--   - customer_name      -> Customer name (BPCNAM_0).
-- Notes:
--   - Considers only orders where ALLQTY_0 > 0 (some quantity is allocated).
--   - Based on SORDER (header) and SORDERQ (lines) tables.

SELECT DISTINCT
    O.SOHNUM_0 AS sales_order_number,
    O.BPCNAM_0 AS customer_name
FROM x3v12.X.SORDER O
LEFT JOIN x3v12.PORTAX1.SORDERQ Q
    ON O.SOHNUM_0 = Q.SOHNUM_0
WHERE Q.ALLQTY_0 > 0
  AND O.BPCINV_0 = '--Customer'   -- :customer_code
  AND O.SALFCY_0 = '--Facility';  -- :facility_code
