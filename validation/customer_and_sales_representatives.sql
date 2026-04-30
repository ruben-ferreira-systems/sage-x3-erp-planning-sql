-- Purpose: List customers and their assigned sales representatives.
-- Context: Used to review and validate the assignment of sales reps (REP_0, REP_1) to customers in Sage X3.
-- Inputs:
--   - (none explicit) -> Full customer set; filters can be applied externally if required.
-- Outputs:
--   - customer_code   -> Customer code (BPCNUM_0).
--   - customer_name   -> Customer name (BPCNAM_0).
--   - sales_rep_1     -> Primary sales representative (REP_0).
--   - sales_rep_2     -> Secondary sales representative (REP_1).
-- Notes:
--   - Based on BPCUSTOMER, BPADDRESS, and BPCUSTMVT.
--   - Can be extended with additional fields for reporting (region, segment, etc.).

SELECT DISTINCT
    BP.BPCNUM_0 AS customer_code,
    BP.BPCNAM_0 AS customer_name,
    BP.REP_0    AS sales_rep_1,
    BP.REP_1    AS sales_rep_2
FROM x3v12.X.BPCUSTOMER AS BP
LEFT JOIN x3v12.X.BPADDRESS AS BD
    ON BP.BPCNUM_0 = BD.BPANUM_0
LEFT JOIN x3v12.X.BPCUSTMVT AS BM
    ON BP.BPCNUM_0 = BM.BPCNUM_0;
