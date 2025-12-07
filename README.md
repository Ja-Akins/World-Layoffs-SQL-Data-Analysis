# World Layoffs Data Analysis - SQL Project

## Project Overview
This project performs **Data Cleaning** and **Exploratory Data Analysis (EDA)** on a dataset of global company layoffs from 2020 to 2023. The goal was to transform raw, messy data into a clean, usable format and then analyze it to uncover trends, outliers, and patterns in the economic landscape.

**Dataset:** [World Layoffs 2022 on Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
**Tools Used:** SQL (MySQL), Workbench

## File Structure
* `Data_Cleaning.sql`: Contains the full SQL script used to clean the raw data.
* `Exploratory_Data_Analysis.sql`: Contains the SQL script used for exploratory analysis and finding trends.

---

## Data Cleaning Process
The raw data contained duplicates, null values, and inconsistent formatting. The cleaning process involved the following steps:

1.  **Data Staging:** Created a staging table to preserve the raw data and ensure a safe workspace for data manipulation.
2.  **Removing Duplicates:**
    * Identified duplicates using `ROW_NUMBER()` and `PARTITION BY` across all columns.
    * Removed duplicate entries to ensure data integrity.
3.  **Standardizing Data:**
    * Corrected spelling variations in company names and industries (e.g., standardizing "Crypto Currency" to "Crypto").
    * Trimmed whitespace and trailing characters from country names.
    * Converted the `date` column from string format to standard `DATE` format.
4.  **Handling Null Values:**
    * Populated missing industry data by performing a self-join to look up existing data for the same company.
    * Removed rows/columns that contained excessive missing values (specifically where both `total_laid_off` and `percentage_laid_off` were NULL).

## Exploratory Data Analysis (EDA)
After cleaning, I performed an in-depth analysis to answer key business questions:

* **Timeline Analysis:** How have layoffs trended over time?
    * *Technique:* `GROUP BY`, `ORDER BY`, Time Series Analysis.
* **Company Impact:** Which companies had the biggest single-day layoffs? Which had the most cumulative layoffs?
    * *Technique:* Aggregate Functions (`SUM`, `MAX`), `LIMIT`.
* **Industry & Country Reach:** Which industries and countries were hit hardest?
    * *Technique:* `GROUP BY` location and industry.
* **Rolling Totals:** What was the cumulative total of layoffs month-over-month?
    * *Technique:* Common Table Expressions (CTEs) and Window Functions (`OVER`, `PARTITION BY`).

## Key Findings & Insights
* **Peak Layoffs:** Identified the peak months for layoffs to understand market volatility.
* **Sector Vulnerability:** Determined that the Tech and Retail industries faced the highest volume of layoffs.
* **Geographic Distribution:** The United States accounted for the majority of the data, but significant impact was observed in India and the Netherlands.

## SQL Skills Demonstrated
* **Data Cleaning:** `UPDATE`, `ALTER TABLE`, `DELETE`
* **Window Functions:** `ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`
* **CTEs (Common Table Expressions):** For complex rolling calculations.
* **Joins:** Self-joins for data population.
* **Aggregations:** `GROUP BY`, `SUM`, `COUNT`.

---

*Author: Benjamin Akingbade - www.linkedin.com/in/benjamin-akingbade-306022251*
