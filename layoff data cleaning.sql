USE layoff_by_world;

SELECT * FROM layoffs;

-- Understand the Data
-- Handle Duplicate Data
-- Standardize Data
-- Handle Missing Data
-- Remove any unwanted Columns if needed

-- Stagging the data
CREATE TABLE layoffs_stage LIKE layoffs;
SELECT * FROM layoffs_stage;

INSERT layoffs_stage SELECT * FROM layoffs;

-- Identifying Dublicates Data

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', 
stage, country, funds_raised_millions) as row_num FROM layoffs_stage;

WITH dublicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, 
country, funds_raised_millions) as row_num FROM layoffs_stage
)
SELECT * FROM dublicate_cte WHERE row_num > 1;

SELECT * FROM layoffs_stage WHERE company = 'Cazoo';

-- Creating a new copy of the table because i can't delete dublicates in the cte in mysql

CREATE TABLE `layoffs_stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_stage2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, 
country, funds_raised_millions) as row_num FROM layoffs_stage;

SELECT * FROM layoffs_stage2 WHERE row_num > 1;

-- Deleting the dublicates
DELETE FROM layoffs_stage2 WHERE row_num > 1;

-- DONE REMOVING THE DUBLICATES DATA
SELECT * FROM layoffs_stage2;

-- Standardize the data
SELECT company, TRIM(company)
from layoffs_stage2;

UPDATE layoffs_stage2
SET company = TRIM(company);

SELECT industry FROM layoffs_stage2 ORDER BY 1;

UPDATE layoffs_stage2
SET industry = "Crypto"
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_stage2
ORDER BY country;

UPDATE layoffs_stage2
SET country = TRIM(TRAILING '.' FROM country);

SELECT DISTINCT country
FROM layoffs_stage2
ORDER BY country;

UPDATE layoffs_stage2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- now convert the data type
ALTER TABLE layoffs_stage2
MODIFY COLUMN `date` DATE;


SELECT * FROM layoffs_stage2;
 -- Done with stand.....
 
 
-- Removing the NULL values where its posssible

SELECT *
FROM layoffs_stage2
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs_stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- SET SQL_SAFE_UPDATES = 0; 

-- Delete useless data
DELETE FROM layoffs_stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_stage2;

ALTER TABLE layoffs_stage2 DROP COLUMN row_num;

-- Handling blanck values
SELECT * FROM layoffs_stage2
WHERE industry = '';

UPDATE layoffs_stage2
SET industry = NULL WHERE industry = '';

SELECT * FROM layoffS_stage2 WHERE industry IS NULL;

UPDATE layoffs_stage2 t1
JOIN layoffs_stage2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL