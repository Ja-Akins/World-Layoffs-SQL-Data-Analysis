# 🌍 World Layoffs Data Analysis: An End-to-End SQL Project (2020-2023)

## Project Overview
This project performs an **end-to-end SQL analysis** focusing on **Data Cleaning** and **Exploratory Data Analysis (EDA)** of global company layoffs from 2020 to 2023. The goal was to transform raw, messy data into a clean, usable dataset and then leverage SQL to uncover critical economic trends and patterns.

**Dataset:** [World Layoffs 2023 on Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
**Tools Used:** SQL (MySQL), Workbench

## 📁 File Structure
* `Data_Cleaning.sql`: Contains the complete SQL script used to prepare the raw data for analysis.
* `Exploratory_Data_Analysis.sql`: Contains the SQL script used for in-depth analysis and trend identification.

---

## 🛠️ Data Cleaning Process (SQL Implementation)
The raw data presented common challenges including duplicates, null values, and inconsistent formatting. The cleaning process, conducted entirely in SQL, focused on achieving data integrity:

1. **Data Staging:** Created a staging table to safeguard the original raw data before manipulation.
2. **Removing Duplicates:**
    * Used the powerful combination of the `ROW_NUMBER()` window function with `PARTITION BY` to uniquely identify and subsequently remove exact duplicate entries.
3. **Standardizing Data:**
    * Performed targeted `UPDATE` statements to correct spelling (e.g., merging "Crypto Currency" and "Crypto") and standardize company/industry names.
    * Trimmed whitespace and converted the text-based `date` column into the standard `DATE` format.
4. **Handling Null Values:**
    * **Data Enrichment via Self-Join:** Populated missing industry data by performing a self-join on the company name, looking up known industry values.
    * Removed rows where key metrics (`total_laid_off` and `percentage_laid_off`) were concurrently NULL, as these provided no analytical value.

## 📈 Exploratory Data Analysis (EDA)
Following the cleaning phase, an in-depth analysis was conducted using advanced SQL techniques to derive actionable insights:

* **Timeline Analysis:** Tracked layoff trends over time using `GROUP BY YEAR()` and `GROUP BY MONTH()` .
* **Rolling Totals:** Calculated the cumulative total of layoffs month-over-month using **CTEs** and the `SUM() OVER(ORDER BY month)` window function .
* **Impact Ranking:** Identified companies, industries, and countries with the highest cumulative and single-day layoff figures using aggregate functions (`SUM`, `MAX`) and `LIMIT`.

## 🔍 Key Findings & Insights

The analysis revealed a sharp, concentrated response by global companies to market pressures:

* **The 2023 Surge:** While 2022 had the highest total layoffs (**160,661**), the 2023 total of **125,677** is particularly significant as it was reached in **just the first three months** of the year, confirming an unprecedented pace of cuts.
* **Sector Vulnerability:** The **Consumer** (**45,182**) and **Retail** (**43,613**) industries faced the highest cumulative volume of layoffs, slightly exceeding the widely reported Tech sector.
* **Corporate Stage:** The vast majority of layoffs occurred at mature, **Post-IPO** companies (**204,132**), indicating that efficiency drives were led by public firms.
* **Key Contributors:** **Amazon** (**18,150**) and **Google** (**12,000**) led the overall company totals, with the **United States** accounting for the vast majority of all global layoffs (**256,559**).

---

## 💻 SQL Skills Demonstrated
* **Window Functions:** `ROW_NUMBER()`, `SUM() OVER(ORDER BY)`, `PARTITION BY`
* **CTEs (Common Table Expressions):** For efficient management of multi-step, complex calculations (e.g., Rolling Totals).
* **Joins:** Self-joins for sophisticated data imputation/population.
* **Core SQL:** Strong command of `GROUP BY`, `SUM`, `COUNT`, `UPDATE`, `ALTER TABLE`, and `DELETE` operations.

---

*Author: Benjamin Akingbade - www.linkedin.com/in/benjamin-akingbade-306022251*
