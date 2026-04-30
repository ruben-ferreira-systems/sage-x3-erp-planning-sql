-- Purpose: Compare stock by item across multiple facilities (sites) and identify "negative" or pending stock at the main site.
-- Context: Used to discuss stock redistribution between sites and highlight items with stock issues at the main site.
-- Inputs:
--   - :main_site       -> Main site (M.STOFCY_0).
--   - :facility1       -> Facility code 1 (STOFCY_0).
--   - :facility2       -> Facility code 2.
--   - :facility3       -> Facility code 3.
--   - :facility4       -> Facility code 4.
--   - :facility5       -> Facility code 5.
--   - :facility6       -> Facility code 6.
-- Outputs:
--   - main_site        -> Main site.
--   - origin_site      -> Manufacturing / origin site (YFCYDEF_0).
--   - item_code        -> Item code.
--   - uom_code         -> Unit of measure.
--   - negative_stock   -> Calculated quantity (WAISTO_0 - PHYSTO_0 - TRASTO_0) at the main site.
--   - item_description -> Item description.
--   - STK106, STK201, STK202, STK301, STK302, STK501 -> Stock quantities by facility.
-- Notes:
--   - Uses subqueries to summarise stock by facility (S106, S201, etc.).
--   - The HAVING filter selects only items where the calculated "negative stock" is greater than zero.

SELECT
    M.STOFCY_0 AS main_site,
    I.YFCYDEF_0 AS origin_site,
    M.ITMREF_0 AS item_code,
    I.STU_0 AS uom_code,
    SUM(M.WAISTO_0 - M.PHYSTO_0 - M.TRASTO_0) AS negative_stock,
    I.YITMDES_0 AS item_description,
    S106.STK106,
    S201.STK201,
    S202.STK202,
    S301.STK301,
    S302.STK302,
    S501.STK501
FROM x3v12.X.ITMMVT M
LEFT JOIN x3v12.X.ITMMASTER I
    ON I.ITMREF_0 = M.ITMREF_0
LEFT JOIN (
    SELECT
        M106.ITMREF_0,
        SUM(M106.PHYSTO_0 - M106.WAISTO_0 - M106.TRASTO_0) AS STK106
    FROM x3v12.PORTAX1.ITMMVT M106
    WHERE M106.STOFCY_0 = --FACILITY1--
    GROUP BY M106.ITMREF_0
) S106 ON S106.ITMREF_0 = M.ITMREF_0
-- (rest of subqueries unchanged, just keep consistent formatting)
GROUP BY
    M.ITMREF_0,
    I.YFCYDEF_0,
    I.STU_0,
    I.YITMDES_0,
    M.STOFCY_0,
    S106.STK106,
    S201.STK201,
    S202.STK202,
    S301.STK301,
    S302.STK302,
    S501.STK501
HAVING SUM(M.WAISTO_0 - M.PHYSTO_0 - M.TRASTO_0) > 0
ORDER BY
    origin_site,
    main_site;
