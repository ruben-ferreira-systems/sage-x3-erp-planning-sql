# Sage X3 Data Work — SQL in Production Environments

This repository contains SQL queries developed in a live industrial environment running **Sage X3**.  
The scripts were used to support **production planning**, **stock validation**, and **day-to-day operational decisions**.

---

## Context

- **Companies:** 4  
- **Factories:** 5  
- **Warehouses:** 5  
- **ERP:** Sage X3 (multi-company, multi-site)

The queries were executed directly against the Sage X3 database (read-only) as part of:

- Regular production planning and stock reviews  
- Ad-hoc analysis for operations, planning, and finance  
- Data quality checks before planning runs or reporting  

---

## Scope of the Work

The SQL in this repository was used to:

- Support **production planning workflows**
- Validate **stock and transaction data**
- Traverse **BOM structures** for material planning
- Reconcile differences between **expected vs actual** data
- Replace or complement **slow ERP screens/queries (Syracuse)**

The focus is on **practical, targeted queries** rather than general-purpose reporting.

---

## Repository Structure

/bom         BOM and material requirements
/stock       Inventory visibility and stock adjustments
/orders      Sales, orders, and delivery-related views
/validation  Master-data and data-quality checks

### `/bom` — Bill of Materials & Material Requirements

Queries under `/bom` work with **BOM structures** and **component requirements**.

Example:

- `bom_material_requirements_from_open_sales.sql`  
  Recursive BOM expansion starting from open sales orders, used to estimate component demand and compare it with current stock.

---

### `/stock` — Stock Visibility & Adjustments

The `/stock` folder focuses on **inventory visibility** and **stock-related data quality**, including normal stock and manual adjustments (miscellaneous movements).

Examples:

- `stock_by_item_and_facility.sql`  
  Snapshot of available stock by item and site/facility.

- `stock_transactions_detailed.sql`  
  Detailed stock movements (excluding miscellaneous receipts/issues) used for operational analysis and troubleshooting.

- `stock_miscellaneous_receipts_by_description.sql`  
  Analysis of manual stock adjustments by movement description to understand recurring reasons for corrections.

- `stock_miscellaneous_receipts_by_item_and_date.sql`  
  Summary of miscellaneous receipts/issues by date and item for audit and process improvement.

---

### `/orders` — Sales Orders & Deliveries

Queries under `/orders` support **sales order analysis**, **allocation visibility**, and **delivery information**.

Examples:

- `sales_by_item_and_month_for_customer.sql`  
  Monthly item-level sold quantities for a given customer and year, adjusted for credit and debit notes.

- `sales_orders_with_allocated_quantity.sql`  
  Sales orders with allocated quantities for a specific customer and facility, used in planning and customer service.

- `sales_orders_item_quantities.sql`  
  Total ordered quantities by item across a selected set of sales orders.

- `delivery_notes_observations.sql`  
  Extraction of free-text observations from delivery notes (RTF to plain text) for review and analysis.

---

### `/validation` — Master Data & Data Quality

The `/validation` folder contains queries that check **master data consistency** and support **code mappings**.

Examples:

- `data_quality_item_uom_consistency.sql`  
  Identifies items where stock quantities do not align with unit conversion factors, signalling potential UoM configuration issues.

- `customer_master_data_overview.sql`  
  Overview of customer master data (identification, classification, payment terms, sales reps, and contact details).

- `item_code_to_supplier_item_code.sql` and  
  `customer_item_code_to_internal_item_code.sql`  
  Mappings between internal item codes and supplier/customer-specific item codes.

- `customer_and_sales_representatives.sql`  
  View of customers and their assigned sales representatives.

These scripts were frequently used when preparing data for planning, reporting, or system changes.

---

## Constraints and Real-World Conditions

These queries were built under real operational constraints:

- **Incomplete or inconsistent data**  
  Many scripts include checks or filters to avoid misleading results when data is not perfect.

- **Performance limitations of ERP interfaces**  
  Some queries were created specifically to replace slow or blocking ERP screens (Syracuse) with faster direct SQL.

- **Need for quick iteration and immediate usability**  
  Most queries started as practical responses to specific questions from planning, production, or finance and evolved over time.

They should be read as **practical solutions to concrete problems**, not as generic templates.
