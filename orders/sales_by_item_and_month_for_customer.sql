-- Purpose: Show monthly sold quantities by item for a specific customer in a given year, adjusted for credit and debit notes.
-- Context: Used to analyse a customer's purchasing pattern by item and month, based on posted sales invoices.
-- Inputs:
--   - :year           -> Calendar year to analyse (YEAR(SJ.ACCDAT_0)).
--   - :customer_code  -> Customer code (SJ.BPR_0).
-- Outputs:
--   - item_code       -> Item reference (ITMREF_0).
--   - JAN..DEC        -> Net quantity sold per month (in invoice unit), adjusted by:
--                        + FCL% (invoices)
--                        - NCC% (credit notes)
--                        + NDC% (debit notes)
-- Notes:
--   - Based on SINVOICE (header) and SINVOICED (lines) tables in Sage X3.
--   - Assumes document number prefixes FCL, NCC, NDC identify invoices, credit notes, and debit notes respectively.

SELECT
    SD.ITMREF_0 AS item_code,

    SUM(ISNULL(CASE
            WHEN MONTH(SJ.ACCDAT_0) = 1 AND SJ.NUM_0 LIKE 'FCL%' THEN SD.QTY_0
        END, 0))
  - SUM(ISNULL(CASE
            WHEN MONTH(SJ.ACCDAT_0) = 1 AND SJ.NUM_0 LIKE 'NCC%' THEN SD.QTY_0
        END, 0))
  + SUM(ISNULL(CASE
            WHEN MONTH(SJ.ACCDAT_0) = 1 AND SJ.NUM_0 LIKE 'NDC%' THEN SD.QTY_0
        END, 0)) AS JAN,

    -- repetir o mesmo padrão para meses 2..12 (FEV..DEC)

FROM x3v12.X.SINVOICE SJ
LEFT JOIN x3v12.X.SINVOICED SD
    ON SD.NUM_0 = SJ.NUM_0
WHERE YEAR(SJ.ACCDAT_0) = -- :year --
  AND SJ.BPR_0 = -- :customer_code --
GROUP BY
    SD.ITMREF_0;
