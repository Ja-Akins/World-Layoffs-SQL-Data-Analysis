/*
Exploratory Data Analysis (EDA): World Layoffs
Dataset: https://www.kaggle.com/datasets/swaptr/layoffs-2022
Description: exploring the data to identify trends, patterns, and outliers regarding global layoffs.
*/

-- --------------------------------------------------------------------------------
-- 1. GENERAL CHECKS & HIGH-LEVEL STATS
-- Checking the scale of layoffs and identifying extreme cases.
-- --------------------------------------------------------------------------------

SELECT * FROM world_layoffs.layoffs_staging2;

-- Max total layoffs and max percentage in a single event
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layoffs.layoffs_staging2;

-- Identify companies that laid off 100% of their workforce (went under)
-- Ordered by funds raised to see the biggest failures
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- --------------------------------------------------------------------------------
-- 2. BREAKDOWN BY COMPANY & INDUSTRY
-- Identifying which companies and industries were hit the hardest.
-- --------------------------------------------------------------------------------

-- Top 10 Companies by Total Layoffs (All time)
SELECT company, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 Industries by Total Layoffs
SELECT industry, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;


-- --------------------------------------------------------------------------------
-- 3. GEOGRAPHIC & STAGE ANALYSIS
-- Analyzing layoffs by location and company funding stage.
-- --------------------------------------------------------------------------------

-- Top 10 Countries by Total Layoffs
SELECT country, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;

-- Layoffs by Funding Stage (e.g., Post-IPO, Series B, etc.)
SELECT stage, SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- --------------------------------------------------------------------------------
-- 4. TEMPORAL ANALYSIS (TRENDS OVER TIME)
-- Looking at year-over-year trends and rolling totals.
-- --------------------------------------------------------------------------------

-- Total Layoffs by Year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Rolling Total of Layoffs (Month by Month)
WITH Rolling_Total AS
(
	SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
	FROM world_layoffs.layoffs_staging2
	WHERE SUBSTRING(`date`,1,7) IS NOT NULL
	GROUP BY `month`
	ORDER BY 1 ASC
)
SELECT `month`, total_off,
SUM(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;


-- --------------------------------------------------------------------------------
-- 5. ADVANCED RANKING
-- Ranking the top companies with the most layoffs per year.
-- --------------------------------------------------------------------------------

WITH Company_Year (company, years, total_laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM world_layoffs.layoffs_staging2
	GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
	SELECT *, 
	DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
	FROM Company_Year
	WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;