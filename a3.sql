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
-- Ques unavailable

-- 12. Rank Scores
SELECT score, DENSE_RANK() OVER (
    ORDER BY score DESC
    ) AS rank
FROM Scores
ORDER BY score DESC;

-- 13. Consecutive Numbers

WITH x AS (
    SELECT id, num,
        LAG(num, 1) OVER (ORDER BY id) AS prev1,
        LAG(num, 2) OVER (ORDER BY id) AS prev2
    FROM Logs
)
SELECT DISTINCT num AS ConsecutiveNums
FROM x
WHERE num = prev1 AND num = prev2;

-- 14. Exchange Seats
SELECT id,
    CASE
        WHEN id % 2 = 1 THEN
            COALESCE(LEAD(student) OVER (ORDER BY id), student)
        ELSE
            LAG(student) OVER (ORDER BY id)
    END AS student
FROM Seat
ORDER BY id;

-- 15. Second Highest Salary
WITH Ranked AS (SELECT salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT MAX(salary) AS SecondHighestSalary
FROM Ranked
WHERE rnk = 2;

-- 16. Nth Highest Salary

-- 17. Department Highest Salary
WITH Ranked AS (
    SELECT id, name, salary, departmentId,
        DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC) AS rnk
    FROM Employee
)
SELECT
    d.name AS Department, r.name AS Employee, r.salary AS Salary
FROM Ranked r
JOIN Department d
    ON r.departmentId = d.id
WHERE r.rnk = 1;

-- 18. Game Play Analysis IV
WITH x AS (
    SELECT player_id, event_date,
        MIN(event_date) OVER (PARTITION BY player_id) AS first_login
    FROM Activity
)
SELECT
    ROUND(1.0 * COUNT(DISTINCT CASE
            WHEN event_date = DATEADD(day, 1, first_login)
            THEN player_id
        END)/ COUNT(DISTINCT player_id), 2
    ) AS fraction
FROM x;

-- 19. User Activity for the Past 30 Days I
-- 20. Department Top Three Salaries 
