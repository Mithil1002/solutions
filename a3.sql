-- Part A
-- 1. Higher Than 75 Marks
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID;

-- 2. Weather Observation Station 5
SELECT TOP 1 CITY, LEN(CITY) FROM STATION
ORDER BY LEN(CITY), CITY;

SELECT TOP 1 CITY, LEN(CITY) FROM STATION
ORDER BY LEN(CITY) DESC, CITY;

-- 3. The Blunder 
SELECT CAST(CEILING(
    AVG(CAST(Salary AS FLOAT))
    -
    AVG(CAST(REPLACE(CAST(Salary AS VARCHAR), '0', '') AS FLOAT))
)AS INT)
FROM EMPLOYEES;
-- 4. The PADS
SELECT Name + '(' + LEFT(Occupation, 1) + ')'
FROM OCCUPATIONS
ORDER BY Name;

SELECT
    'There are a total of ' + CAST(COUNT(*) AS VARCHAR) + ' ' + LOWER(Occupation) + 's.'
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation;

-- 5. Occupations
WITH ranked AS(
    SELECT Name, Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation
            ORDER BY Name) AS rn
    FROM OCCUPATIONS)
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM ranked
GROUP BY rn
ORDER BY rn;

-- 6. Patients With a Condition
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions LIKE 'DIAB1%'
   OR conditions LIKE '% DIAB1%';

-- 7. Invalid Tweets
SELECT tweet_id FROM Tweets
WHERE LEN(content) > 15;

-- 8. Fix Names in a Table
SELECT user_id, UPPER(LEFT(name, 1)) + LOWER(SUBSTRING(name, 2, LEN(name))) AS name
FROM Users
ORDER BY user_id;

-- 9. Calculate Special Bonus 
SELECT employee_id,
    CASE
        WHEN employee_id % 2 = 1 AND name NOT LIKE 'M%'
        THEN salary
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id;



-- Part B

-- 10. Game Play Analysis I
SELECT DISTINCT
    player_id,
    MIN(event_date) OVER (PARTITION BY player_id) AS first_login
FROM Activity;

-- 11. Game Play Analysis II

-- 12. Rank Scores
SELECT score, DENSE_RANK() OVER (
    ORDER BY score DESC
    ) AS rank
FROM Scores
ORDER BY score DESC;

-- 13. Consecutive Numbers
