# Local Store Sales & Inventory Analysis

---

## Project Overview

This project analyzes one full year of retail sales and inventory data for a local store.
It identifies high-demand products, seasonal demand patterns, stock inefficiencies,
and provides data-driven recommendations for inventory optimization.

**Tools Used:** SQL · Python (Pandas, Matplotlib) · Microsoft Excel  
**Dataset:** 140 Sales Records | 20 Inventory Products | 4 Regional Stores

---

## Folder Structure

```
sales_inventory_project/
│
├── data/
│   ├── sales_data.csv          ← 140 sales transaction records (2024)
│   └── inventory_data.csv      ← 20 product inventory records
│
├── sql/
│   └── sales_inventory_analysis.sql   ← 12 analysis SQL queries
│
├── python/
│   └── analysis.py             ← Data cleaning + 8 Matplotlib charts
│
├── charts/                     ← Auto-generated PNG charts (run analysis.py)
│   ├── chart1_top10_revenue.png
│   ├── chart2_monthly_revenue_trend.png
│   ├── chart3_category_revenue_pie.png
│   ├── chart4_quarterly_performance.png
│   ├── chart5_stock_vs_reorder.png
│   ├── chart6_region_revenue.png
│   ├── chart7_profit_margin_category.png
│   └── chart8_stock_status_donut.png
│
├── excel/
│   └── Sales_Inventory_Dashboard.xlsx  ← 4-sheet interactive dashboard
│
└── README.md                   
```

---

## How to Run

### Step 1: Install Python Dependencies
```bash
pip install pandas matplotlib openpyxl numpy
```

### Step 2: Run Python Analysis (generates all 8 charts)
```bash
cd sales_inventory_project
python python/analysis.py
```

### Step 3: Run SQL Queries
Open `sql/sales_inventory_analysis.sql` in:
- MySQL Workbench, or
- DB Browser for SQLite, or
- Any SQL client

## Key Findings

| Metric | Value |
|--------|-------|
| Total Annual Revenue | Rs. 8,17,036 |
| Total Units Sold | 12,340 |
| Peak Month | December 2024 (Rs. 88,790) |
| Products Below Reorder Level | 7 (35%) |
| Out of Stock Products | 1 (Basmati Rice 5kg) |

**Top 3 Products by Revenue:**
1. Detergent Powder — Rs. 1,33,200
2. Rice (5kg) — Rs. 1,11,600
3. Sunflower Oil (1L) — Rs. 1,10,330

---

## SQL Concepts Demonstrated
- `JOINs` (INNER JOIN, LEFT JOIN)
- Aggregate functions (`SUM`, `AVG`, `COUNT`, `ROUND`)
- `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`
- `CASE WHEN` for conditional logic
- Date functions (`YEAR()`, `MONTH()`, `QUARTER()`, `MONTHNAME()`)
- Subqueries for percentage calculations

## Python Concepts Demonstrated
- Data loading and cleaning with **Pandas**
- `groupby`, `merge`, `describe`, `pivot`
- 8 chart types with **Matplotlib** (bar, line, pie, donut)
- Derived columns and conditional flagging

## Excel Features Demonstrated
- 4-sheet workbook (Dashboard, Sales Data, Inventory, Analysis Summary)
- KPI metric cards with color-coded formatting
- Conditional row coloring based on stock status
- Embedded line, bar, and pie charts
- Data validation and formula-driven cells


