"""
============================================================
  LOCAL STORE SALES & INVENTORY ANALYSIS
  Python Script: Data Cleaning, Analysis & Visualization
  Tools Used   : Pandas, Matplotlib, NumPy
  Author       : MCA Project | Data Analysis Resume Project
============================================================
"""

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import numpy as np
import os
import warnings
warnings.filterwarnings("ignore")

# ── Output folder ────────────────────────────────────────────
OUTPUT_DIR = "charts"
os.makedirs(OUTPUT_DIR, exist_ok=True)

COLORS = {
    "blue"      : "#2563EB",
    "green"     : "#16A34A",
    "orange"    : "#EA580C",
    "purple"    : "#7C3AED",
    "red"       : "#DC2626",
    "teal"      : "#0D9488",
    "slate"     : "#475569",
    "palette"   : ["#2563EB","#16A34A","#EA580C","#7C3AED",
                   "#DC2626","#0D9488","#F59E0B","#EC4899"],
}

plt.rcParams.update({
    "font.family"   : "DejaVu Sans",
    "axes.spines.top"   : False,
    "axes.spines.right" : False,
    "axes.grid"     : True,
    "grid.alpha"    : 0.3,
    "grid.linestyle": "--",
})


# ============================================================
# STEP 1: LOAD DATA
# ============================================================
print("=" * 55)
print("  LOCAL STORE SALES & INVENTORY ANALYSIS")
print("=" * 55)

sales_df = pd.read_csv("data/sales_data.csv")
inv_df   = pd.read_csv("data/inventory_data.csv")

print(f"\n[INFO] Sales records loaded     : {len(sales_df)}")
print(f"[INFO] Inventory records loaded : {len(inv_df)}")


# ============================================================
# STEP 2: DATA CLEANING & PREPROCESSING
# ============================================================
print("\n--- Data Cleaning ---")

# Convert date
sales_df["date"] = pd.to_datetime(sales_df["date"])

# Check for missing values
print("\nMissing values – Sales:")
print(sales_df.isnull().sum())
print("\nMissing values – Inventory:")
print(inv_df.isnull().sum())

# Remove duplicates
sales_df.drop_duplicates(subset="sale_id", inplace=True)
inv_df.drop_duplicates(subset="product_id", inplace=True)

# Derived columns
sales_df["month"]   = sales_df["date"].dt.month
sales_df["month_name"] = sales_df["date"].dt.strftime("%b")
sales_df["quarter"] = sales_df["date"].dt.quarter
sales_df["year"]    = sales_df["date"].dt.year

# Stock shortage flag
inv_df["stock_shortage"] = inv_df["current_stock"] < inv_df["reorder_level"]
inv_df["gross_margin"]   = ((inv_df["unit_price"] - inv_df["unit_cost"]) /
                             inv_df["unit_price"] * 100).round(2)

print("\n[INFO] Cleaning complete. No null values found.")
print("\n--- Basic Statistics – Sales ---")
print(sales_df[["quantity_sold","unit_price","total_revenue"]].describe().round(2))


# ============================================================
# STEP 3: ANALYSIS
# ============================================================

# 3a. Total revenue & units per product
product_summary = (
    sales_df.groupby(["product_id","product_name","category"])
    .agg(total_units=("quantity_sold","sum"),
         total_revenue=("total_revenue","sum"))
    .reset_index()
    .sort_values("total_revenue", ascending=False)
)

# 3b. Monthly revenue trend
monthly = (
    sales_df.groupby(["year","month","month_name"])
    .agg(monthly_revenue=("total_revenue","sum"),
         units_sold=("quantity_sold","sum"))
    .reset_index()
    .sort_values(["year","month"])
)
MONTH_ORDER = ["Jan","Feb","Mar","Apr","May","Jun",
               "Jul","Aug","Sep","Oct","Nov","Dec"]
monthly["month_name"] = pd.Categorical(monthly["month_name"], categories=MONTH_ORDER, ordered=True)
monthly = monthly.sort_values("month_name")

# 3c. Category-wise revenue
category_rev = (
    sales_df.groupby("category")
    .agg(total_revenue=("total_revenue","sum"),
         units_sold=("quantity_sold","sum"))
    .reset_index()
    .sort_values("total_revenue", ascending=False)
)

# 3d. Quarterly trend
quarterly = (
    sales_df.groupby("quarter")
    .agg(quarterly_revenue=("total_revenue","sum"),
         units_sold=("quantity_sold","sum"))
    .reset_index()
)
quarterly["quarter_label"] = "Q" + quarterly["quarter"].astype(str)

# 3e. Region-wise performance
region_rev = (
    sales_df.groupby("region")
    .agg(total_revenue=("total_revenue","sum"),
         total_units=("quantity_sold","sum"))
    .reset_index()
    .sort_values("total_revenue", ascending=False)
)

# 3f. Merged: Sales + Inventory
merged = pd.merge(product_summary, inv_df, on="product_id", how="inner")
merged["avg_monthly_demand"] = (merged["total_units"] / 12).round(0)
merged["restock_urgent"]     = merged["current_stock"] < merged["avg_monthly_demand"]

# Print key findings
print("\n--- Top 5 Products by Revenue ---")
print(product_summary[["product_name","total_units","total_revenue"]].head())

print("\n--- Monthly Revenue Summary ---")
print(monthly[["month_name","monthly_revenue","units_sold"]])

print("\n--- Inventory: Products Below Reorder Level ---")
print(inv_df[inv_df["stock_shortage"]][["product_name","current_stock","reorder_level","stock_status"]])


# ============================================================
# STEP 4: VISUALIZATIONS
# ============================================================

def save(fname):
    path = os.path.join(OUTPUT_DIR, fname)
    plt.savefig(path, dpi=150, bbox_inches="tight")
    plt.close()
    print(f"[SAVED] {path}")


# ── Chart 1: Top 10 Products by Revenue (Horizontal Bar) ────
fig, ax = plt.subplots(figsize=(10, 6))
top10 = product_summary.head(10).sort_values("total_revenue")
bars = ax.barh(top10["product_name"], top10["total_revenue"],
               color=COLORS["blue"], edgecolor="white", linewidth=0.5)
for bar in bars:
    ax.text(bar.get_width() + 500, bar.get_y() + bar.get_height()/2,
            f'₹{bar.get_width():,.0f}', va="center", fontsize=8, color=COLORS["slate"])
ax.set_xlabel("Total Revenue (₹)", fontsize=10)
ax.set_title("Top 10 Products by Revenue (2024)", fontsize=13, fontweight="bold")
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
plt.tight_layout()
save("chart1_top10_revenue.png")


# ── Chart 2: Monthly Revenue Trend (Line Chart) ─────────────
fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(monthly["month_name"], monthly["monthly_revenue"],
        color=COLORS["blue"], marker="o", linewidth=2.5, markersize=7)
ax.fill_between(range(len(monthly)), monthly["monthly_revenue"],
                alpha=0.12, color=COLORS["blue"])
for i, (mn, rev) in enumerate(zip(monthly["month_name"], monthly["monthly_revenue"])):
    ax.annotate(f'₹{rev/1000:.1f}K', (i, rev), textcoords="offset points",
                xytext=(0, 8), ha="center", fontsize=7.5, color=COLORS["slate"])
ax.set_xticks(range(len(monthly)))
ax.set_xticklabels(monthly["month_name"])
ax.set_ylabel("Revenue (₹)", fontsize=10)
ax.set_title("Monthly Sales Revenue Trend – 2024", fontsize=13, fontweight="bold")
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
plt.tight_layout()
save("chart2_monthly_revenue_trend.png")


# ── Chart 3: Category-wise Revenue (Pie Chart) ──────────────
fig, ax = plt.subplots(figsize=(8, 7))
wedges, texts, autotexts = ax.pie(
    category_rev["total_revenue"],
    labels=category_rev["category"],
    autopct="%1.1f%%",
    colors=COLORS["palette"][:len(category_rev)],
    startangle=140,
    pctdistance=0.80,
    wedgeprops=dict(edgecolor="white", linewidth=1.5)
)
for at in autotexts:
    at.set_fontsize(9)
ax.set_title("Revenue Share by Product Category (2024)", fontsize=13, fontweight="bold")
plt.tight_layout()
save("chart3_category_revenue_pie.png")


# ── Chart 4: Quarterly Sales Performance (Bar Chart) ────────
fig, ax = plt.subplots(figsize=(7, 5))
bars = ax.bar(quarterly["quarter_label"], quarterly["quarterly_revenue"],
              color=COLORS["palette"][:4], edgecolor="white", linewidth=0.8, width=0.5)
for bar in bars:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1000,
            f'₹{bar.get_height()/1000:.1f}K', ha="center", fontsize=9, fontweight="bold")
ax.set_ylabel("Revenue (₹)", fontsize=10)
ax.set_title("Quarterly Revenue Performance – 2024", fontsize=13, fontweight="bold")
ax.yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
plt.tight_layout()
save("chart4_quarterly_performance.png")


# ── Chart 5: Current Stock vs Reorder Level (Grouped Bar) ───
fig, ax = plt.subplots(figsize=(13, 6))
x = np.arange(len(inv_df))
w = 0.38
b1 = ax.bar(x - w/2, inv_df["current_stock"],  width=w, label="Current Stock",  color=COLORS["blue"],  alpha=0.85)
b2 = ax.bar(x + w/2, inv_df["reorder_level"],  width=w, label="Reorder Level",  color=COLORS["orange"], alpha=0.85)
ax.set_xticks(x)
ax.set_xticklabels(inv_df["product_name"], rotation=45, ha="right", fontsize=8)
ax.set_ylabel("Units", fontsize=10)
ax.set_title("Current Stock vs Reorder Level by Product", fontsize=13, fontweight="bold")
ax.legend(fontsize=10)
# Highlight shortage bars
for i, (cs, rl) in enumerate(zip(inv_df["current_stock"], inv_df["reorder_level"])):
    if cs < rl:
        ax.axvspan(i - 0.45, i + 0.45, alpha=0.08, color=COLORS["red"])
plt.tight_layout()
save("chart5_stock_vs_reorder.png")


# ── Chart 6: Region-wise Revenue (Horizontal Bar) ───────────
fig, ax = plt.subplots(figsize=(8, 4))
bars = ax.barh(region_rev["region"], region_rev["total_revenue"],
               color=COLORS["teal"], edgecolor="white")
for bar in bars:
    ax.text(bar.get_width() + 200, bar.get_y() + bar.get_height()/2,
            f'₹{bar.get_width():,.0f}', va="center", fontsize=9)
ax.set_xlabel("Total Revenue (₹)", fontsize=10)
ax.set_title("Region-wise Revenue Performance (2024)", fontsize=13, fontweight="bold")
ax.xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f"₹{x/1000:.0f}K"))
plt.tight_layout()
save("chart6_region_revenue.png")


# ── Chart 7: Profit Margin by Category (Bar) ────────────────
cat_margin = (
    inv_df.groupby("category")
    .agg(avg_margin=("gross_margin","mean"))
    .reset_index()
    .sort_values("avg_margin", ascending=False)
)
fig, ax = plt.subplots(figsize=(8, 5))
colors_m = [COLORS["green"] if m >= 40 else COLORS["orange"] if m >= 25 else COLORS["red"]
            for m in cat_margin["avg_margin"]]
bars = ax.bar(cat_margin["category"], cat_margin["avg_margin"],
              color=colors_m, edgecolor="white")
for bar in bars:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5,
            f'{bar.get_height():.1f}%', ha="center", fontsize=9, fontweight="bold")
ax.set_ylabel("Avg Gross Margin (%)", fontsize=10)
ax.set_title("Average Profit Margin by Category", fontsize=13, fontweight="bold")
ax.axhline(y=30, color=COLORS["slate"], linestyle="--", linewidth=1, label="30% benchmark")
ax.legend()
plt.tight_layout()
save("chart7_profit_margin_category.png")


# ── Chart 8: Stock Status Distribution (Donut Chart) ─────────
status_counts = inv_df["stock_status"].value_counts()
status_colors = {
    "Adequate"    : COLORS["green"],
    "Low Stock"   : COLORS["orange"],
    "Critical Low": COLORS["red"],
    "Out of Stock": "#111827",
    "Overstocked" : COLORS["purple"],
}
fig, ax = plt.subplots(figsize=(7, 6))
wedges, texts, autotexts = ax.pie(
    status_counts.values,
    labels=status_counts.index,
    autopct="%1.0f%%",
    colors=[status_colors.get(s, COLORS["blue"]) for s in status_counts.index],
    startangle=90,
    pctdistance=0.78,
    wedgeprops=dict(width=0.55, edgecolor="white", linewidth=2)
)
for at in autotexts:
    at.set_fontsize(10)
ax.set_title("Inventory Stock Status Distribution", fontsize=13, fontweight="bold")
plt.tight_layout()
save("chart8_stock_status_donut.png")


# ============================================================
# STEP 5: SUMMARY REPORT (Printed)
# ============================================================
total_rev   = sales_df["total_revenue"].sum()
total_units = sales_df["quantity_sold"].sum()
best_month  = monthly.loc[monthly["monthly_revenue"].idxmax(), "month_name"]
best_month_rev = monthly["monthly_revenue"].max()
low_stock   = inv_df[inv_df["stock_shortage"]]["product_name"].tolist()
out_of_stock = inv_df[inv_df["stock_status"] == "Out of Stock"]["product_name"].tolist()

print("\n" + "=" * 55)
print("  EXECUTIVE SUMMARY")
print("=" * 55)
print(f"  Total Revenue (2024)     : ₹{total_rev:,.0f}")
print(f"  Total Units Sold         : {total_units:,}")
print(f"  Avg Revenue per Sale     : ₹{sales_df['total_revenue'].mean():,.0f}")
print(f"  Peak Sales Month         : {best_month} (₹{best_month_rev:,.0f})")
print(f"  Products – Low/Critical  : {len(low_stock)}")
print(f"  Products – Out of Stock  : {len(out_of_stock)}")
print(f"  Products – Overstocked   : {len(inv_df[inv_df['stock_status']=='Overstocked'])}")
print("\n  Top 3 Revenue Products:")
for _, row in product_summary.head(3).iterrows():
    print(f"    • {row['product_name']} — ₹{row['total_revenue']:,}")
print("\n  Products Needing Restock:")
for p in low_stock:
    print(f"    ⚠  {p}")
if out_of_stock:
    print("\n  Out of Stock (Immediate Action):")
    for p in out_of_stock:
        print(f"    ✘  {p}")
print("\n  All charts saved to /charts/")
print("=" * 55)
