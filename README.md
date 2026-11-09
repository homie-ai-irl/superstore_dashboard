# Superstore Sales Dashboard

An end-to-end sales analytics project on the Global Superstore dataset: data validated with **SQL Server (T-SQL)** and visualised in an interactive **Power BI** dashboard covering sales, profit, logistics and returns.

## Table of Contents
- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Dataset](#dataset)
- [Data Model](#data-model)
- [Dashboard Pages](#dashboard-pages)
- [Key Metrics (DAX Measures)](#key-metrics-dax-measures)
- [SQL Validation Queries](#sql-validation-queries)
- [Getting Started](#getting-started)
- [Tools & Technologies](#tools--technologies)
- [Notes](#notes)

## Overview

The goal of this project is to turn raw transactional order data into a dashboard that answers questions such as:

- How do sales, profit, quantity and order volume change over time (2012–2015)?
- Which countries, markets, categories, sub-categories and customers drive the most revenue?
- How healthy is the profit margin, and how does it move by quarter?
- How much do shipping costs weigh on sales, and how do they differ by market, ship mode, segment and order priority?
- How large is the return rate, measured by both sales value and number of orders?

The SQL queries in `Query_check.sql` were used to cross-check the numbers shown in Power BI.

## Repository Structure

```
Superstore_Dashboard/
├── data/
│   ├── orders.csv              # Order line items (51,290 rows, 24 columns)
│   ├── returns.csv             # Returned orders (1,079 rows)
│   └── people.csv              # Regional managers (24 rows, no header)
├── Query_check.sql             # T-SQL queries to validate dashboard KPIs
├── superstore_dashboard.pbix   # Power BI report
└── README.md
```

## Dataset

| File | Description | Key columns |
|------|-------------|-------------|
| `orders.csv` | One row per order line item, 2012-01-01 to 2015-12-31 | Order ID, Order Date, Ship Date, Ship Mode, Customer, Segment, Country, Region, Market, Category, Sub-Category, Sales, Quantity, Discount, Profit, Shipping Cost, Order Priority |
| `returns.csv` | Orders that were returned | Returned, Order ID, Region |
| `people.csv` | Regional manager for each of the 24 regions | Manager name, Region |

**Scale:** ~25.7K orders · ~17.4K customers · 3,788 products · 165 countries · 23 regions · 5 markets (Africa, Asia Pacific, Europe, LATAM, USCA).

**Dimensions:**
- **Segment:** Consumer, Corporate, Home Office
- **Category:** Furniture, Office Supplies, Technology
- **Ship Mode:** Same Day, First Class, Second Class, Standard Class
- **Order Priority:** Critical, High, Medium, Low

## Data Model

The Power BI model follows a star-schema style layout:

- `fact_orders` – transactional order lines (sales, quantity, discount, profit, shipping cost)
- `fact_returns` – returned orders, linked to `fact_orders` via `Order ID`
- `dim_date` – calendar table (Year, Quarter, Month, Month Name, Year-Quarter) used for time-based analysis
- `_measure` – dedicated table holding all DAX measures

## Dashboard Pages

| Page | Content |
|------|---------|
| **Introduction** | Landing page with project description and navigation buttons |
| **Overview** | Headline KPI cards (Total Sales, Profit, Quantity, Shipping Cost, Total Orders), yearly trends, sales map by country, sales by category and segment, top countries table |
| **Sale** | Sales by category/sub-category (treemap and table), profit margin over time, sub-category sales vs. profit scatter by quarter, top customers by sales, segment share of sales over time |
| **Logistic** | Total shipping cost, shipping cost as % of sales, shipping cost trend, and shipping cost per quantity by market, ship mode, segment and order priority |
| **Return** | Sales return rate and order return rate with trends over time, filtered to returned orders |

All pages share interactive slicers for **Year, Month, Market and Segment**, plus page navigation buttons.

## Key Metrics (DAX Measures)

- **Total Sales**, **Total Orders**
- **ROS** (Return on Sales / profit margin)
- **Shipping cost on Total Sales**
- **Shipping cost per quantity**
- **Sales return rate**
- **Order return rate...**

## SQL Validation Queries

`Query_check.sql` contains T-SQL queries (SQL Server) run against `dbo.fact_orders` and `dbo.fact_returns`:

| Group | Queries |
|-------|---------|
| Volume | Total orders, total quantity (overall and by year) |
| Revenue & profit | Total sales, total profit, total shipping cost (overall and by year) |
| Ranking | Top 10 countries by sales, top 10 customers by sales |
| Mix | Sales distribution by segment over time (window function, % of yearly total) |
| Profitability | Profit margin by year and quarter |
| Logistics | Shipping cost as % of total sales |
| Returns | Total return sales, total return orders, sales return rate, order return rate |

## Getting Started

1. **Clone the repository**
   ```bash
   git clone git@github.com:homie-ai-irl/superstore_dashboard.git
   ```
2. **Open the dashboard** – open `superstore_dashboard.pbix` in [Power BI Desktop](https://powerbi.microsoft.com/desktop/). If prompted, update the data source path to the local `data/` folder and refresh.
3. **(Optional) Reproduce the SQL checks**
   - Import `orders.csv` and `returns.csv` into SQL Server as `dbo.fact_orders` and `dbo.fact_returns` (column names with spaces replaced by underscores, e.g. `Order_ID`, `Order_Date`, `Shipping_Cost`).
   - Run the queries in `Query_check.sql`.

## Tools & Technologies

- **Power BI Desktop** – data modelling, DAX, visualisation (including Azure Map and custom visuals)
- **SQL Server / T-SQL** – data validation with aggregations, CTEs and window functions
- **CSV** – source data

## Notes

- In `orders.csv`, monetary fields (`Sales`, `Profit`) are stored as text such as `$221.98` and negative values as `($288.77)`, so they must be cleaned and cast to numeric types before analysis.
- Dates use the `M/D/YYYY` format.
- `Postal Code` is empty for most non-US rows.
- `people.csv` has no header row.
- A "return" is determined at **order level**: the return rates compare all line items of returned orders against the total.
- The report contains a hidden `Temp` page used for development only.