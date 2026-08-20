SELECT 
COUNT(job_id) AS job_count,
EXTRACT(month FROM job_posted_date) AS month
FROM job_postings_fact
WHERE job_title_short='Data Analyst'
group by month
order by job_count;

SELECT 
AVG(salary_year_avg) AS  avg_per_year,
AVG(salary_hour_avg) AS avg_per_year,
job_schedule_type
FROM 
job_postings_fact 
WHERE  
job_posted_date >='1-6-2023'
GROUP BY job_schedule_type
LIMIT 10


SELECT
COUNT(job_id) AS jobs,
EXTRACT (MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York') AS month

FROM 
job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York')=2023
GROUP BY month
ORDER BY month







SELECT 
    EXTRACT (MONTH FROM job_posted_date) AS months,
    job_postings_fact.job_health_insurance,
    company_dim.name
FROM job_postings_fact
LEFT JOIN company_dim 
ON company_dim.company_id=job_postings_fact.company_id
WHERE 
    EXTRACT (MONTH FROM job_posted_date) in (4,5,6)
    AND EXTRACT (YEAR FROM job_posted_date) =2023
    AND job_postings_fact.job_health_insurance = TRUE
ORDER BY months;

SELECT DISTINCT
    company_dim.name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON company_dim.company_id = job_postings_fact.company_id
WHERE 
    job_postings_fact.job_health_insurance = TRUE
    AND EXTRACT(QUARTER FROM job_posted_date) = 2
    AND EXTRACT(YEAR FROM job_posted_date) = 2023;






CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=1
    order by job_posted_date;

CREATE TABLE faburuary_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=2
    order by job_posted_date;

CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date)=3
    order by job_posted_date;



SELECT 
COUNT(job_id) AS num_of_jobs,
CASE
    WHEN job_location='Anywhere' THEN 'Remote'
    WHEN job_location='New York, NY' THEN 'Local'
    ELSE 'On Site'
END AS location_category
FROM job_postings_fact
WHERE job_title_short='Data Analyst'
GROUP BY location_category





SELECT *
FROM(
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date)=1
)AS data_analyst_jobs;
LIMIT 100

WITH data_analyst_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
)
SELECT *
FROM data_analyst_jobs;


SELECT 
COUNT(skill_id) ,
job_id
FROM skills_job_dim
GROUP BY job_id

LIMIT 100

   
   
SELECT
skills_dim.skills,
top_skills.skill_count
   FROM (
    SELECT 
        skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim
    GROUP BY skill_id
    ORDER BY skill_count DESC
    LIMIT 50
   )AS top_skills

JOIN skills_dim
ON top_skills.skill_id=skills_dim.skill_id
order by top_skills DESC;

SELECT 
job_id ,
salary_year_avg,
CASE
WHEN salary_year_avg<50000 THEN 'low salary'
WHEN salary_year_avg BETWEEN 50000 AND 100000 THEN 'standard salary'
ELSE 'high salary'

END AS salary_rating

FROM job_postings_fact
WHERE job_title_short ='Data Analyst' AND salary_year_avg IS NOT NULL
order by salary_year_avg DESC

/*SELECT 
companies_classification,
COUNT(*) AS company_count
FROM(
    SELECT 
    company_id,
    number_of_jobs,
    CASE
    WHEN number_of_jobs<10 THEN 'small companies'
    WHEN number_of_jobs<=50 THEN 'medium companies'
    ELSE 'large companies'
    END AS companies_classification

    FROM(
        SELECT 
        company_id,
        COUNT(job_id) AS number_of_jobs
        FROM job_postings_fact
        WHERE job_title_short ='Data Analyst'
        GROUP BY company_id
    ) AS job_postings
)AS company_sizes
GROUP BY companies_classification
*/

WITH job_posting AS (
    SELECT 
        company_id,
        COUNT(job_id) AS number_of_jobs
    FROM job_postings_fact
    WHERE job_title_short ='Data Analyst'
    GROUP BY company_id
),
company_size AS(
    SELECT 
    company_id,
    number_of_jobs,
    CASE
    WHEN number_of_jobs<10 THEN 'small companies'
    WHEN number_of_jobs<=50 THEN 'medium companies'
    ELSE 'large companies'
    END AS companies_classification
    FROM job_posting
)
SELECT
    companies_classification,
    COUNT(*) AS company_count
FROM company_size
GROUP BY companies_classification






 