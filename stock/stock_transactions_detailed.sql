-- Purpose: List detailed stock movements in a given date/time range by location, item, and site.
-- Context: Used for movement analysis, auditing, and investigating stock differences.
-- Inputs:
--   - :start_datetime  -> Start of the date/time range (CREDATTIM_0 >=).
--   - :end_datetime    -> End of the date/time range (CREDATTIM_0 <=).
--   - :site_code       -> Site/facility (STOFCY_0).
--   - :user_exclusions -> (Optional) list of users to exclude.
-- Outputs:
--   - location         -> Physical location (LOC_0).
--   - item_code        -> Item code (ITMREF_0).
--   - item_description -> Main item description.
--   - site_code        -> Site/facility.
--   - uom_code         -> Stock unit of measure.
--   - status_code      -> Stock status (STA_0).
--   - document_number  -> Document number (VCRNUM_0).
--   - created_by       -> User who created the movement.
--   - quantity         -> Moved quantity (QTYSTU_0).
-- Notes:
--   - Excludes "miscellaneous receipts" (ENT%) and "miscellaneous issues" (SAI%).
--   - Focuses on movements where the net quantity is not zero (SUM(QTYSTU_0) <> 0).

SELECT
    STJ.LOC_0         AS location,
    STJ.ITMREF_0      AS item_code,
    ITM.ITMDES1_0     AS item_description,
    STJ.STOFCY_0      AS site_code,
    ITM.STU_0         AS uom_code,
    STJ.STA_0         AS status_code,
    VCRNUM_0          AS document_number,
    STJ.CREUSR_0      AS created_by,
    SUM(STJ.QTYSTU_0) AS quantity
FROM x3v12.X.STOJOU STJ
INNER JOIN x3v12.X.ITMMASTER ITM
    ON STJ.ITMREF_0 = ITM.ITMREF_0
WHERE STJ.CREDATTIM_0 <= '2023-01-17 08:30:00.000'
  AND STJ.CREDATTIM_0 >= '2023-01-03 18:00:00.000'
  AND STJ.STOFCY_0 = '--STOFCY_0--'
  AND VCRNUM_0 NOT LIKE 'ENT%' -- Ignore miscellaneous receipts
  AND VCRNUM_0 NOT LIKE 'SAI%' -- Ignore miscellaneous issues
  -- AND STJ.CREUSR_0 NOT IN (-- :user_exclusions --)
GROUP BY
    STJ.STOFCY_0,
    STJ.ITMREF_0,
    ITM.ITMDES1_0,
    ITM.STU_0,
    STJ.LOC_0,
    STJ.STA_0,
    VCRNUM_0,
    STJ.CREUSR_0
HAVING SUM(STJ.QTYSTU_0) <> 0
ORDER BY
    STJ.STOFCY_0,
    STJ.LOC_0;
