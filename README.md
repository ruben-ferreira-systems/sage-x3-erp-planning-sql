# Sage X3 Data Work — SQL in Production Environments

This repository contains SQL queries developed in a live industrial environment to support production planning, data validation, and operational decision-making.

## Context

- 4 companies
- 5 factories
- 5 warehouses
- ERP: Sage X3

## Scope

The queries in this repository were used to:

- Support production planning workflows
- Validate stock and transaction data
- Traverse BOM structures for material planning
- Reconcile discrepancies across systems
- Replace slow or blocking ERP queries (Syracuse)

## Key Areas

### BOM (Bill of Materials)
- Recursive queries to expand multi-level BOM structures
- Used for material requirement analysis

### Stock Validation
- Cross-site stock visibility
- Identification of inconsistencies between systems

### Order Tracking
- Linking sales orders, allocations, and stock
- Supporting planning decisions

### Data Reconciliation
- Identifying gaps between expected and actual data
- Supporting corrective operations

## Notes

These queries were built under real operational constraints:
- Incomplete or inconsistent data
- Performance limitations of ERP interfaces
- Need for fast iteration and immediate usability

They should be read as practical solutions, not theoretical models.
