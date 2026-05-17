-- ============================================================
--  LOCAL STORE SALES & INVENTORY ANALYSIS
--  SQL Script: Schema Creation, Data Loading & Analysis Queries
--  Database : MySQL / SQLite Compatible
-- ============================================================


-- ============================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS local_store_db;
USE local_store_db;


-- ============================================================
-- SECTION 2: TABLE CREATION
-- ============================================================

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS inventory;

-- Sales Table
CREATE TABLE sales (
    sale_id         INT PRIMARY KEY,
    sale_date       DATE NOT NULL,
    product_id      VARCHAR(10) NOT NULL,
    product_name    VARCHAR(100),
    category        VARCHAR(50),
    quantity_sold   INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    total_revenue   DECIMAL(12,2) NOT NULL,
    store_id        VARCHAR(10),
    region          VARCHAR(30)
);

-- Inventory Table
CREATE TABLE inventory (
    product_id          VARCHAR(10) PRIMARY KEY,
    product_name        VARCHAR(100),
    category            VARCHAR(50),
    current_stock       INT NOT NULL,
    reorder_level       INT NOT NULL,
    reorder_quantity    INT,
    unit_cost           DECIMAL(10,2),
    unit_price          DECIMAL(10,2),
    supplier            VARCHAR(100),
    last_restocked      DATE,
    warehouse_location  VARCHAR(30),
    stock_status        VARCHAR(30)
);


-- ============================================================
-- SECTION 3: INSERT SAMPLE DATA
-- ============================================================

-- Sales Data (truncated sample – load full CSV in production)
INSERT INTO sales VALUES
(1001,'2024-01-03','P001','Rice (5kg)','Groceries',45,120,5400,'S01','North'),
(1002,'2024-01-04','P002','Wheat Flour (10kg)','Groceries',30,95,2850,'S01','North'),
(1003,'2024-01-05','P003','Sunflower Oil (1L)','Groceries',60,110,6600,'S02','South'),
(1004,'2024-01-06','P004','Sugar (1kg)','Groceries',80,45,3600,'S02','South'),
(1005,'2024-01-07','P005','Toothpaste','Personal Care',50,65,3250,'S03','East'),
(1006,'2024-01-08','P006','Shampoo (200ml)','Personal Care',35,120,4200,'S03','East'),
(1007,'2024-01-10','P007','Detergent Powder','Household',40,180,7200,'S01','North'),
(1008,'2024-01-11','P008','Biscuits (Family Pack)','Snacks',90,55,4950,'S04','West'),
(1009,'2024-01-12','P009','Cold Drink (2L)','Beverages',75,60,4500,'S04','West'),
(1010,'2024-01-13','P010','Milk (1L)','Dairy',120,22,2640,'S02','South'),
(1016,'2024-02-01','P001','Rice (5kg)','Groceries',60,120,7200,'S01','North'),
(1019,'2024-02-05','P007','Detergent Powder','Household',50,180,9000,'S01','North'),
(1020,'2024-02-06','P008','Biscuits (Family Pack)','Snacks',95,55,5225,'S04','West'),
(1021,'2024-02-07','P010','Milk (1L)','Dairy',130,22,2860,'S02','South'),
(1026,'2024-02-15','P009','Cold Drink (2L)','Beverages',90,60,5400,'S03','East'),
(1031,'2024-03-01','P001','Rice (5kg)','Groceries',70,120,8400,'S01','North'),
(1033,'2024-03-04','P009','Cold Drink (2L)','Beverages',110,60,6600,'S03','East'),
(1034,'2024-03-05','P008','Biscuits (Family Pack)','Snacks',100,55,5500,'S04','West'),
(1035,'2024-03-07','P010','Milk (1L)','Dairy',140,22,3080,'S01','North'),
(1036,'2024-03-08','P007','Detergent Powder','Household',55,180,9900,'S02','South'),
(1046,'2024-04-01','P001','Rice (5kg)','Groceries',65,120,7800,'S01','North'),
(1047,'2024-04-02','P009','Cold Drink (2L)','Beverages',130,60,7800,'S04','West'),
(1050,'2024-04-07','P010','Milk (1L)','Dairy',150,22,3300,'S01','North'),
(1051,'2024-04-08','P007','Detergent Powder','Household',60,180,10800,'S02','South'),
(1056,'2024-05-01','P009','Cold Drink (2L)','Beverages',160,60,9600,'S01','North'),
(1057,'2024-05-02','P001','Rice (5kg)','Groceries',75,120,9000,'S02','South'),
(1060,'2024-05-07','P010','Milk (1L)','Dairy',160,22,3520,'S01','North'),
(1062,'2024-05-10','P007','Detergent Powder','Household',65,180,11700,'S03','East'),
(1066,'2024-06-01','P009','Cold Drink (2L)','Beverages',200,60,12000,'S01','North'),
(1067,'2024-06-02','P001','Rice (5kg)','Groceries',80,120,9600,'S02','South'),
(1069,'2024-06-05','P010','Milk (1L)','Dairy',170,22,3740,'S04','West'),
(1072,'2024-06-10','P007','Detergent Powder','Household',70,180,12600,'S03','East'),
(1076,'2024-07-01','P009','Cold Drink (2L)','Beverages',220,60,13200,'S01','North'),
(1078,'2024-07-03','P001','Rice (5kg)','Groceries',85,120,10200,'S02','South'),
(1079,'2024-07-05','P010','Milk (1L)','Dairy',175,22,3850,'S03','East'),
(1082,'2024-07-10','P007','Detergent Powder','Household',72,180,12960,'S03','East'),
(1086,'2024-08-01','P009','Cold Drink (2L)','Beverages',210,60,12600,'S01','North'),
(1087,'2024-08-02','P001','Rice (5kg)','Groceries',80,120,9600,'S03','East'),
(1089,'2024-08-05','P010','Milk (1L)','Dairy',168,22,3696,'S02','South'),
(1092,'2024-08-10','P007','Detergent Powder','Household',68,180,12240,'S04','West'),
(1096,'2024-09-01','P001','Rice (5kg)','Groceries',75,120,9000,'S01','North'),
(1097,'2024-09-02','P009','Cold Drink (2L)','Beverages',160,60,9600,'S04','West'),
(1098,'2024-09-03','P010','Milk (1L)','Dairy',160,22,3520,'S02','South'),
(1099,'2024-09-05','P007','Detergent Powder','Household',65,180,11700,'S03','East'),
(1106,'2024-10-01','P001','Rice (5kg)','Groceries',70,120,8400,'S01','North'),
(1107,'2024-10-02','P007','Detergent Powder','Household',60,180,10800,'S02','South'),
(1108,'2024-10-03','P010','Milk (1L)','Dairy',155,22,3410,'S03','East'),
(1111,'2024-10-09','P009','Cold Drink (2L)','Beverages',120,60,7200,'S02','South'),
(1116,'2024-11-01','P001','Rice (5kg)','Groceries',80,120,9600,'S01','North'),
(1117,'2024-11-02','P007','Detergent Powder','Household',65,180,11700,'S02','South'),
(1118,'2024-11-03','P010','Milk (1L)','Dairy',165,22,3630,'S03','East'),
(1122,'2024-11-10','P009','Cold Drink (2L)','Beverages',90,60,5400,'S03','East'),
(1126,'2024-12-01','P001','Rice (5kg)','Groceries',90,120,10800,'S01','North'),
(1127,'2024-12-02','P007','Detergent Powder','Household',70,180,12600,'S02','South'),
(1129,'2024-12-05','P010','Milk (1L)','Dairy',175,22,3850,'S04','West'),
(1131,'2024-12-09','P009','Cold Drink (2L)','Beverages',100,60,6000,'S02','South');

-- Inventory Data
INSERT INTO inventory VALUES
('P001','Rice (5kg)','Groceries',120,100,300,85,120,'AgriSupply Co.','2024-12-01','Aisle A1','Adequate'),
('P002','Wheat Flour (10kg)','Groceries',45,60,200,65,95,'AgriSupply Co.','2024-11-20','Aisle A2','Low Stock'),
('P003','Sunflower Oil (1L)','Groceries',200,80,250,78,110,'OilMart Traders','2024-12-05','Aisle A3','Adequate'),
('P004','Sugar (1kg)','Groceries',95,70,300,30,45,'SweetGoods Ltd.','2024-11-28','Aisle A4','Adequate'),
('P005','Toothpaste','Personal Care',80,50,150,42,65,'CareLife Corp.','2024-12-01','Aisle B1','Adequate'),
('P006','Shampoo (200ml)','Personal Care',55,40,120,80,120,'CareLife Corp.','2024-11-25','Aisle B2','Adequate'),
('P007','Detergent Powder','Household',30,50,180,110,180,'CleanHome Pvt.','2024-11-15','Aisle C1','Low Stock'),
('P008','Biscuits (Family Pack)','Snacks',180,100,300,35,55,'SnackWorld Ltd.','2024-12-03','Aisle D1','Adequate'),
('P009','Cold Drink (2L)','Beverages',250,150,400,38,60,'BevCo Distributors','2024-12-02','Aisle E1','Adequate'),
('P010','Milk (1L)','Dairy',90,80,200,15,22,'FreshDairy Farms','2024-12-08','Fridge F1','Adequate'),
('P011','Soap Bar','Personal Care',140,60,200,18,30,'CareLife Corp.','2024-11-30','Aisle B3','Adequate'),
('P012','Noodles (Pack)','Snacks',220,80,250,9,15,'SnackWorld Ltd.','2024-12-01','Aisle D2','Adequate'),
('P013','Butter (100g)','Dairy',25,40,100,38,55,'FreshDairy Farms','2024-11-10','Fridge F2','Low Stock'),
('P014','Chips (Large)','Snacks',160,90,250,25,40,'SnackWorld Ltd.','2024-12-04','Aisle D3','Adequate'),
('P015','Green Tea (Box)','Beverages',60,30,100,58,90,'BevCo Distributors','2024-11-22','Aisle E2','Adequate'),
('P016','Cornflakes (500g)','Breakfast',15,40,120,45,75,'CerealBrand Inc.','2024-10-30','Aisle A5','Critical Low'),
('P017','Instant Coffee (100g)','Beverages',18,35,100,70,110,'BevCo Distributors','2024-11-01','Aisle E3','Critical Low'),
('P018','Cooking Salt (1kg)','Groceries',300,100,300,8,15,'AgriSupply Co.','2024-11-20','Aisle A6','Overstocked'),
('P019','Tomato Ketchup','Condiments',12,30,100,28,45,'FoodBrand Co.','2024-10-25','Aisle G1','Critical Low'),
('P020','Basmati Rice (5kg)','Groceries',8,50,200,140,200,'AgriSupply Co.','2024-10-15','Aisle A7','Out of Stock');


-- ============================================================
-- SECTION 4: ANALYSIS QUERIES
-- ============================================================

-- ─────────────────────────────────────────
-- Q1: Total Revenue and Units Sold per Product (Top 10)
-- ─────────────────────────────────────────
SELECT 
    product_id,
    product_name,
    category,
    SUM(quantity_sold)              AS total_units_sold,
    SUM(total_revenue)              AS total_revenue,
    ROUND(AVG(quantity_sold), 2)    AS avg_units_per_sale
FROM sales
GROUP BY product_id, product_name, category
ORDER BY total_revenue DESC
LIMIT 10;


-- ─────────────────────────────────────────
-- Q2: Monthly Sales Trend (Revenue by Month)
-- ─────────────────────────────────────────
SELECT 
    YEAR(sale_date)     AS year,
    MONTH(sale_date)    AS month,
    MONTHNAME(sale_date) AS month_name,
    COUNT(sale_id)      AS total_transactions,
    SUM(quantity_sold)  AS total_units_sold,
    SUM(total_revenue)  AS monthly_revenue
FROM sales
GROUP BY YEAR(sale_date), MONTH(sale_date), MONTHNAME(sale_date)
ORDER BY year, month;


-- ─────────────────────────────────────────
-- Q3: Category-wise Sales Performance
-- ─────────────────────────────────────────
SELECT 
    category,
    COUNT(DISTINCT product_id)      AS total_products,
    SUM(quantity_sold)              AS total_units_sold,
    SUM(total_revenue)              AS total_revenue,
    ROUND(AVG(unit_price), 2)       AS avg_unit_price,
    ROUND(SUM(total_revenue) * 100.0 / 
        (SELECT SUM(total_revenue) FROM sales), 2) AS revenue_share_pct
FROM sales
GROUP BY category
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────
-- Q4: Region-wise Revenue Performance
-- ─────────────────────────────────────────
SELECT 
    region,
    store_id,
    COUNT(sale_id)          AS total_transactions,
    SUM(quantity_sold)      AS total_units_sold,
    SUM(total_revenue)      AS total_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_sale
FROM sales
GROUP BY region, store_id
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────
-- Q5: Seasonal Sales Pattern (Quarter-wise)
-- ─────────────────────────────────────────
SELECT 
    QUARTER(sale_date)  AS quarter,
    CONCAT('Q', QUARTER(sale_date)) AS quarter_label,
    SUM(quantity_sold)  AS total_units_sold,
    SUM(total_revenue)  AS total_revenue,
    COUNT(sale_id)      AS total_transactions
FROM sales
GROUP BY QUARTER(sale_date)
ORDER BY quarter;


-- ─────────────────────────────────────────
-- Q6: Current Inventory Status (Stock Health Check)
-- ─────────────────────────────────────────
SELECT 
    product_id,
    product_name,
    category,
    current_stock,
    reorder_level,
    (current_stock - reorder_level)     AS stock_buffer,
    stock_status,
    supplier
FROM inventory
ORDER BY 
    CASE stock_status 
        WHEN 'Out of Stock' THEN 1
        WHEN 'Critical Low' THEN 2
        WHEN 'Low Stock'    THEN 3
        WHEN 'Adequate'     THEN 4
        WHEN 'Overstocked'  THEN 5
        ELSE 6 
    END;


-- ─────────────────────────────────────────
-- Q7: Products Needing Immediate Reorder
-- ─────────────────────────────────────────
SELECT 
    product_id,
    product_name,
    category,
    current_stock,
    reorder_level,
    reorder_quantity,
    stock_status,
    supplier,
    last_restocked
FROM inventory
WHERE current_stock <= reorder_level
ORDER BY current_stock ASC;


-- ─────────────────────────────────────────
-- Q8: JOIN — Sales Performance vs. Current Stock Level
-- ─────────────────────────────────────────
SELECT 
    s.product_id,
    s.product_name,
    s.category,
    SUM(s.quantity_sold)        AS total_sold_2024,
    SUM(s.total_revenue)        AS total_revenue,
    i.current_stock,
    i.reorder_level,
    i.stock_status,
    ROUND(SUM(s.quantity_sold) / 12, 0)  AS avg_monthly_demand,
    CASE 
        WHEN i.current_stock < ROUND(SUM(s.quantity_sold)/12, 0) 
        THEN 'RESTOCK URGENT'
        ELSE 'Stock OK'
    END AS restock_flag
FROM sales s
JOIN inventory i ON s.product_id = i.product_id
GROUP BY s.product_id, s.product_name, s.category, 
         i.current_stock, i.reorder_level, i.stock_status
ORDER BY total_revenue DESC;


-- ─────────────────────────────────────────
-- Q9: Profit Margin Analysis (Revenue vs Cost via JOIN)
-- ─────────────────────────────────────────
SELECT 
    s.product_id,
    s.product_name,
    s.category,
    SUM(s.quantity_sold)                        AS units_sold,
    SUM(s.total_revenue)                        AS total_revenue,
    SUM(s.quantity_sold * i.unit_cost)          AS total_cost,
    SUM(s.total_revenue) - 
        SUM(s.quantity_sold * i.unit_cost)      AS gross_profit,
    ROUND(
        (SUM(s.total_revenue) - SUM(s.quantity_sold * i.unit_cost)) 
        * 100.0 / SUM(s.total_revenue), 2)      AS profit_margin_pct
FROM sales s
JOIN inventory i ON s.product_id = i.product_id
GROUP BY s.product_id, s.product_name, s.category
ORDER BY gross_profit DESC;


-- ─────────────────────────────────────────
-- Q10: Supplier-wise Stock Summary
-- ─────────────────────────────────────────
SELECT 
    supplier,
    COUNT(product_id)               AS products_supplied,
    SUM(current_stock)              AS total_stock_units,
    SUM(current_stock * unit_cost)  AS total_inventory_value,
    SUM(CASE WHEN stock_status IN ('Out of Stock','Critical Low','Low Stock') 
             THEN 1 ELSE 0 END)     AS at_risk_products
FROM inventory
GROUP BY supplier
ORDER BY total_inventory_value DESC;


-- ─────────────────────────────────────────
-- Q11: Top 5 High-Demand Products (by Volume)
-- ─────────────────────────────────────────
SELECT 
    product_id,
    product_name,
    category,
    SUM(quantity_sold)  AS total_units_sold
FROM sales
GROUP BY product_id, product_name, category
ORDER BY total_units_sold DESC
LIMIT 5;


-- ─────────────────────────────────────────
-- Q12: Overstocked Products (Slow Movers)
-- ─────────────────────────────────────────
SELECT 
    i.product_id,
    i.product_name,
    i.category,
    i.current_stock,
    i.reorder_level,
    COALESCE(SUM(s.quantity_sold), 0)   AS total_sold_2024,
    CASE 
        WHEN COALESCE(SUM(s.quantity_sold), 0) = 0 THEN 'No Sales — Review'
        WHEN i.current_stock > (i.reorder_level * 2) THEN 'Overstocked'
        ELSE 'Normal'
    END AS stock_health
FROM inventory i
LEFT JOIN sales s ON i.product_id = s.product_id
GROUP BY i.product_id, i.product_name, i.category, 
         i.current_stock, i.reorder_level
HAVING stock_health IN ('Overstocked', 'No Sales — Review')
ORDER BY i.current_stock DESC;
