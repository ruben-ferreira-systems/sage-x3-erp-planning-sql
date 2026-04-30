-- Purpose: Expand multi-level BOM requirements starting from open sales orders and join with current stock per component.
-- Context: Used by planners to estimate component requirements driven by open sales orders and compare them with available stock.
-- Inputs:
--   - :facility_list -> List of facilities/sites (STOFCY_0) to include.
--   - :description_filter -> (Optional) pattern to filter finished product description (YITMDES_0).
-- Outputs:
--   - parent_item      -> Finished product / parent item code (PCodigo).
--   - component_item   -> Component item code (Codigo).
--   - component_desc   -> Component description (Descricao).
--   - bom_quantity     -> Required quantity per parent (Bomqty).
--   - bom_uom          -> BOM unit of measure (UN).
--   - stock_qty        -> Current stock quantity per component (SUM(QTYPCU_0)).
--   - stock_uom        -> Stock unit of measure (PCU_0).
-- Notes:
--   - Implemented as a recursive CTE to traverse BOMD from top-level sales order items down to components.
--   - Includes only open sales order lines (SOQSTA_0 <> 3).
--   - Stock is filtered by facility (STOFCY_0 IN :facility_list).

WITH Nomenclatura (
    PCodigo,
    Codigo,
    Descricao,
    Bomqty,
    UN
) AS (
    -- Anchor: top-level items from open sales orders
    SELECT
        I.ITMREF_0                         AS PCodigo,
        S.ITMREF_0                         AS Codigo,
        I.YITMDES_0                        AS Descricao,
        CAST(SUM(QTY_0 - DLVQTY_0) AS DECIMAL(10, 3)) AS Bomqty,
        SAU_0                              AS UN
    FROM x3v12.X.SORDERQ S
    INNER JOIN x3v12.X.ITMMASTER I
        ON I.ITMREF_0 = S.ITMREF_0
    WHERE S.SOQSTA_0 <> 3
    GROUP BY
        I.ITMREF_0,
        S.ITMREF_0,
        I.YITMDES_0,
        SAU_0

    UNION ALL

    -- Recursive step: explode BOM from parent to component
    SELECT
        N.Codigo                           AS PCodigo,
        B.CPNITMREF_0                      AS Codigo,
        I1.YITMDES_0                       AS Descricao,
        CAST(B.BOMQTY_0 AS DECIMAL(10, 3)) AS Bomqty,
        B.BOMUOM_0                         AS UN
    FROM Nomenclatura N
    INNER JOIN x3v12.X.BOMD B
        ON N.Codigo = B.ITMREF_0
    INNER JOIN x3v12.X.ITMMASTER I1
        ON I1.ITMREF_0 = B.CPNITMREF_0
)
SELECT DISTINCT
    PCodigo         AS parent_item,
    Codigo          AS component_item,
    Descricao       AS component_desc,
    Bomqty          AS bom_quantity,
    UN              AS bom_uom,
    SUM(QTYPCU_0)   AS stock_qty,
    PCU_0           AS stock_uom
FROM Nomenclatura
LEFT JOIN x3v12.X.STOCK S
    ON Nomenclatura.Codigo = S.ITMREF_0
WHERE S.STOFCY_0 IN (-- :facility_list --)
  AND Descricao LIKE -- :description_filter --
GROUP BY
    PCodigo,
    Codigo,
    Descricao,
    Bomqty,
    UN,
    PCU_0;
