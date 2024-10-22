-- layoff by the company group by order by desc
SELECT company, SUM(total_laid_off) AS layoff
FROM layoffs_stage2
group by company
ORDER BY layoff DESC;

SELECT * FROM layoffs_stage2;

-- What is the date in which this layoff happen ATQ data sheet
SELECT MIN(date), MAX(date)
FROM layoffs_stage2;

-- What industry layoff the most
SELECT industry, SUM(total_laid_off) AS layoff
FROM layoffs_stage2
group by industry
ORDER BY layoff DESC;

-- Which contry layoff order by country
SELECT country, SUM(total_laid_off) AS layoff
FROM layoffs_stage2
group by country	
ORDER BY layoff DESC;

-- layoff groupby year
SELECT YEAR(date), SUM(total_laid_off) AS layoff
FROM layoffs_stage2
group by YEAR(date)	
ORDER BY layoff DESC;
