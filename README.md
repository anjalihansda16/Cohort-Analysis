# ShopTrendz E-Commerce: Boosting Retention and Value by Product Category

**Table of Contents**:
- [Project Overview](#project-overview)
- [Business Problem](#business-problem)
- [Executive Summary](#executive-summary)
- [Analytical Approach](#analytical-approach)
   - [Customer Retention by Product Category](#customer-retention-by-product-category)
   - [Revenue Retention by Product Category](#revenue-retention-by-product-category)
   - [CLV by Product Category](#clv-by-product-category)
- [Insights](#insights)
- [Conclusion](#conclusion)
- [Recommendations](#recommendations)

## Project Overview

**ShopTrendz**, an e-commerce platform offering diverse products like Mobiles & Tablets, Beauty & Grooming, and Appliances, aimed to enhance customer retention and revenue to drive profitability. With varied price points (e.g., $1,500+ for Mobiles & Tablets vs. $60 for Books), the company needed to identify which product categories retained customers, sustained revenue, and delivered the highest long-term value (Customer Lifetime Value, CLV). As a data analyst, I used SQL to analyze sales data from October 2020 to September 2021, delivering actionable insights to optimize marketing, inventory, and engagement strategies.

## Business Problem

ShopTrendz faced inconsistent customer retention and revenue across product categories, complicating decisions on marketing and inventory prioritization. The leadership team sought answers to:

- Which product categories retain customers best over six months?
- How much revenue is retained in each category over six months?
- What is the CLV for each category, and how do purchase frequency and average order value (AOV) contribute?

The goal was to pinpoint high-value categories and recommend strategies to boost repeat purchases and profitability.

## Executive Summary
ShopTrendz’s cohort analysis (Oct 2020–Sep 2021) revealed Appliances (16.72% month 1 retention, $3,134.15 CLV, 3.19 orders/customer) and Beauty & Grooming (12.45%, $817.96 CLV) excel in retention and revenue retention (18.12%, 21.89%), while Entertainment ($4,832.54 CLV, $1,692.49 AOV) and Mobiles & Tablets ($4,209.83, $1,588.26 AOV) drive high CLV but low retention (6.51%, 5.51%). Recommendations include prioritizing Appliances with accessory promotions, bundling Beauty & Grooming to boost AOV, targeting Mobiles & Tablets and Entertainment with loyalty programs, launching month 1 discounts to reduce churn, and validating Soghaat’s anomalous data spike (30.7% month 6 revenue retention).

## Analytical Approach

Using a dataset with customer IDs, order dates, categories, and revenue, I developed three SQL analyses, all focused on **product category cohorts** (customers grouped by their first purchased category). This unified approach ensured cohesive insights over a six-month period (first purchases from October 2020 to March 2021). The analyses leveraged exploratory data analysis (EDA) and data quality checks to ensure robustness.

### 1. Customer Retention by Product Category
- Measured the percentage of customers (`pct_active`) returning each month (0–6) after their first purchase.
- Grouped customers by first purchased category, counted active customers per month, and calculated retention rates using `MIN(category)` and `DATEDIFF`.

### 2. Revenue Retention by Product Category
- Calculated the percentage of initial revenue (`pct_revenue_retained`) retained over six months.
- Summed revenue per category and month, compared to month 0, and computed retention rates, focusing on revenue trends without AOV for simplicity.

### 3. CLV by Product Category
- Quantified average CLV, purchase frequency, repeat purchase rate, and AOV to assess long-term value.
- Summed revenue and counted orders per customer over six months, averaged by category, and calculated repeat purchase rate (percentage of customers with >1 order).

## Insights

Based on the cohort analyses, the following insights highlight retention, revenue retention, and CLV trends, with respect to AOV, purchase frequency, and repeat purchase rate:

1. **Customer Retention**:
   - **Appliances** led with 16.72% retention in month 1 (839/5,017 customers), dropping to 2.53% by month 6, reflecting long purchase cycles typical of durable goods (e.g., refrigerators).
   - **Beauty & Grooming** retained 12.45% in month 1 (226/1,815 customers), maintaining 6.17% in month 3, indicating steady repeat purchases for consumables (e.g., cosmetics).
   - **Books** achieved the highest month 1 retention (23.53%, 8/34 customers), but the small cohort limits reliability, suggesting niche loyalty.
   - **Mobiles & Tablets** (5.51%, 240/4,353) and **Men’s Fashion** (5.25%, 261/4,973) showed low retention, indicating one-time purchases dominate these categories.
   - **Soghaat**’s retention spiked to 2.4% in month 6 (from 12.57% in month 1, 167 customers), possibly a data anomaly due to its small cohort.

2. **Revenue Retention**:
   - **Soghaat** led with 55.2% revenue retention in month 1 ($17,180.66/$31,125.62), with a questionable 30.7% spike in month 6, aligning with customer retention and suggesting a bulk order anomaly.
   - **Beauty & Grooming** retained 21.89% in month 1 ($224,716.52/$1,026,798.54), dropping to 4.02% by month 6 but holding 12.13% in month 3, reflecting consistent revenue from repeat purchases.
   - **Health & Sports** achieved 24.28% in month 1 ($40,175.41/$165,446.22), with fluctuations (e.g., 1.27% in month 5), indicating variable purchase patterns, possibly seasonal.
   - **Appliances** retained 18.12% in month 1 ($1,943,513.72/$10,723,012.09), declining to 3.68% by month 6, consistent with low customer retention but supported by high purchase frequency (3.19 orders/customer).
   - **Mobiles & Tablets** had low retention (7.53% in month 1, 0.72% by month 6, $16,749,353.26 base), despite high initial revenue, likely due to single high-value purchases (AOV: $1,588.26 from CLV data).

3. **Customer Lifetime Value (CLV)**:
   - **Entertainment** led with a $4,832.54 CLV (1,393 customers), driven by a high AOV ($1,692.49), moderate frequency (2.7 orders/customer), and strong repeat purchase rate (49.68%). Low revenue retention (6.51% in month 1) suggests one-time high-value purchases (e.g., gaming consoles).
   - **Mobiles & Tablets** achieved a $4,209.83 CLV (4,390 customers), fueled by a high AOV ($1,588.26) and moderate frequency (2.4 orders/customer, 42.8% repeat rate). Low retention (5.51%) indicates limited repeat purchases despite high value.
   - **Appliances** had a $3,134.15 CLV (4,979 customers), supported by the highest frequency (3.19 orders/customer) and repeat purchase rate (52.1%), though a lower AOV ($817.42) tempers CLV compared to Entertainment.
   - **Beauty & Grooming**’s CLV was $817.96 (1,831 customers), constrained by a low AOV ($189.98) despite moderate frequency (1.93 orders/customer) and repeat purchase rate (32.82%), highlighting the need for higher-value sales.
   - **Books** and **School & Education** had the lowest CLV ($101.67 and $98.7, 17 and 43 customers), due to low AOV ($63.01, $63.42), frequency (1.18, 1.16), and repeat purchase rates (17.65%, 6.98%).

## Conclusion: 
Retention Drives Revenue**: Moderate customer retention in Beauty & Grooming (12.45%) and Appliances (16.72%) supports stronger revenue retention (21.89%, 18.12%), as repeat customers contribute consistent revenue. Low retention in Mobiles & Tablets (5.51%) and Entertainment (6.51%) aligns with poor revenue retention (7.53%, 6.51%).
   - **AOV and Frequency Shape CLV**: High AOV drives CLV in Entertainment ($1,692.49) and Mobiles & Tablets ($1,588.26), but low frequency limits repeat revenue. Appliances’ high frequency (3.19) and repeat purchase rate (52.1%) boost CLV despite a moderate AOV ($817.42). Beauty & Grooming’s low AOV ($189.98) restricts CLV, despite moderate frequency.
   - **Repeat Purchases Enhance Value**: Appliances’ 52.1% repeat purchase rate supports its high CLV and revenue retention, while Entertainment’s 49.68% rate is offset by low retention, indicating one-time high-value buyers.
   - **Niche Categories**: Small cohorts (Soghaat, Books) show volatile retention and revenue trends, suggesting niche loyalty but unreliable strategic focus.

## Recommendations

Based on the insights, I recommend the following strategies to enhance retention, revenue, and CLV for ShopTrendz:

1. **Prioritize Appliances**: Increase inventory and promote accessories (e.g., appliance warranties) to leverage high CLV ($3,134.15), frequency (3.19 orders/customer), and repeat purchase rate (52.1%), despite declining retention.
2. **Enhance Beauty & Grooming**: Offer product bundles or subscription models to raise AOV ($189.98) and sustain moderate retention (12.45%) and revenue retention (21.89%), boosting CLV ($817.96).
3. **Target Mobiles & Tablets and Entertainment**: Implement loyalty programs and cross-selling (e.g., phone accessories, gaming peripherals) to improve low retention (5.51%, 6.51%) and maximize high CLV ($4,209.83, $4,832.54) driven by high AOV ($1,588.26, $1,692.49).
4. **Early Engagement Campaigns**: Launch month 1 discounts or personalized offers, especially for low-retention categories like Mobiles & Tablets and Men’s Fashion (5.25%), to increase repeat purchase rates and revenue retention.
5. **Validate Soghaat Data**: Investigate the month 6 spike (30.7% revenue retention) to confirm if it reflects genuine demand or a data error. If valid, target niche customers with premium offerings.