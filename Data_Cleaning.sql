/*
Data Cleaning Project: World Layoffs
Dataset: https://www.kaggle.com/datasets/swaptr/layoffs-2022
Description: This script cleans raw layoff data to prepare it for exploratory data analysis (EDA).
*/


-- 1. DATA STAGING
-- Create a staging table to preserve the raw data and ensure a safe workspace.

SELECT * 
FROM world_layoffs.layoffs;

CREATE TABLE world_layoffs.layoffs_staging 
LIKE world_layoffs.layoffs;

INSERT layoffs_staging 
SELECT * FROM world_layoffs.layoffs;



-- 2. REMOVE DUPLICATES
-- Identify duplicates based on all column values and remove them using a row number method.


-- Check for duplicates
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

-- Create a new table (staging2) with the row_num column to facilitate deletion
CREATE TABLE `world_layoffs`.`layoffs_staging2` (
    `company` text,
    `location` text,
    `industry` text,
    `total_laid_off` int,
    `percentage_laid_off` text,
    `date` text,
    `stage` text,
    `country` text,
    `funds_raised_millions` int,
    `row_num` int
);

-- Insert data into staging2 with the calculated row numbers
INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`, `row_num`)
SELECT 
    `company`, `location`, `industry`, `total_laid_off`, `percentage_laid_off`, `date`, `stage`, `country`, `funds_raised_millions`,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM 
    world_layoffs.layoffs_staging;

-- Delete duplicates (where row_num is 2 or greater)
DELETE FROM world_layoffs.layoffs_staging2
WHERE row_num >= 2;



-- 3. STANDARDIZING DATA
-- Fix spacing, typos, standardizing formatting, and correcting data types.

-- A. Industry Cleanup
-- Update empty strings to NULL for easier logic handling
UPDATE world_layoffs.layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate NULL industry values using data from other rows with the same company name
UPDATE world_layoffs.layoffs_staging2 t1
JOIN world_layoffs.layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Standardize 'Crypto' variations (e.g., 'Crypto Currency' -> 'Crypto')
UPDATE world_layoffs.layoffs_staging2
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');


-- B. Country Cleanup
-- Remove trailing periods (e.g., 'United States.' -> 'United States')
UPDATE world_layoffs.layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);


-- C. Date Formatting
-- Convert string date format to standard DATE type
UPDATE world_layoffs.layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE world_layoffs.layoffs_staging2
MODIFY COLUMN `date` DATE;



-- 4. NULL VALUES & UNNECESSARY DATA
-- Remove useless rows and columns that cannot be used for analysis.

-- Remove rows where both layoff count and percentage are NULL (useless for analysis)
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Drop the helper column used for deduplication
ALTER TABLE world_layoffs.layoffs_staging2
DROP COLUMN row_num;

-- Final data check
SELECT * FROM world_layoffs.layoffs_staging2;