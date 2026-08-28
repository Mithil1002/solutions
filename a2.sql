-- 1. Asian Population
SELECT SUM(c.POPULATION) FROM CITY c
INNER JOIN COUNTRY o ON c.COUNTRYCODE = o.CODE
WHERE o.CONTINENT = 'Asia';

-- 2. African Cities
SELECT c.NAME FROM CITY c JOIN COUNTRY o ON c.countrycode = o.code
WHERE CONTINENT = 'Africa';

-- 3. Average Population of Each Continent
SELECT o.continent, FLOOR(AVG(c.population)) from city c JOIN country o on c.countrycode = o.code 
group by o.continent;

-- 4. The Report
SELECT
    CASE
        WHEN g.Grade < 8 THEN NULL ELSE s.Name
    END AS Name,
    g.Grade, s.Marks FROM Students AS s
INNER JOIN Grades AS g
    ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY
    g.Grade DESC,
    CASE
        WHEN g.Grade >= 8 THEN s.Name END ASC,
    CASE
        WHEN g.Grade < 8 THEN s.Marks END ASC;
		
-- 5. Top Competitors
SELECT w.id, wp.age, w.coins_needed, w.power
FROM Wands AS w
INNER JOIN Wands_Property AS wp
    ON w.code = wp.code
WHERE wp.is_evil = 0 AND w.coins_needed = (
        SELECT MIN(w2.coins_needed)
        FROM Wands AS w2
        INNER JOIN Wands_Property AS wp2
            ON w2.code = wp2.code
        WHERE wp2.is_evil = 0
          AND w2.power = w.power
          AND wp2.age = wp.age
    )
ORDER BY w.power DESC, wp.age DESC;

-- 6. Ollivander's Inventory
SELECT h.hacker_id, h.name FROM Hackers AS h
INNER JOIN Submissions AS s ON h.hacker_id = s.hacker_id
INNER JOIN Challenges AS c ON s.challenge_id = c.challenge_id
INNER JOIN Difficulty AS d ON c.difficulty_level = d.difficulty_level
WHERE s.score = d.score
GROUP BY
    h.hacker_id, h.name
HAVING COUNT(DISTINCT s.challenge_id) > 1
ORDER BY
    COUNT(DISTINCT s.challenge_id) DESC, h.hacker_id ASC;
	
	
-- 7. Symmetric Pairs
SELECT f1.X, f1.Y FROM Functions f1 JOIN Functions f2 
ON f1.X = f2.Y AND f1.Y = f2.X
GROUP BY
    f1.X, f1.Y
HAVING COUNT(*) > 1 OR f1.X < f1.Y
ORDER BY f1.X;

-- 8. SQL Project Planning
SELECT Start_Date, End_Date
FROM (SELECT P.Start_Date,(SELECT MIN(End_Date)
    FROM Projects
    WHERE End_Date > P.Start_Date
        AND End_Date NOT IN (SELECT Start_Date FROM Projects)) AS End_Date
    FROM Projects P
    WHERE Start_Date NOT IN (SELECT End_Date FROM Projects)
) X
ORDER BY DATEDIFF(DAY, Start_Date, End_Date), Start_Date;

-- 9. Placements
SELECT s.Name FROM Students s
JOIN Friends f
    ON s.ID = f.ID
JOIN Packages p1
    ON s.ID = p1.ID
JOIN Packages p2
    ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;

-- 10 Interviews 
-- Aggregate submission stats by challenge → aggregate view stats by challenge → connect contests to colleges and challenges →
-- join the stats → group by contest → sum all metrics → remove all-zero contests → sort by contest ID.

SELECT c.contest_id, c.hacker_id, c.name,
    SUM(COALESCE(ss.total_submissions, 0)) AS total_submissions,
    SUM(COALESCE(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(COALESCE(vs.total_views, 0)) AS total_views,
    SUM(COALESCE(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON col.college_id = ch.college_id

LEFT JOIN (SELECT challenge_id,
        SUM(total_submissions) AS total_submissions,
        SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM Submission_Stats
    GROUP BY challenge_id) ss
    ON ch.challenge_id = ss.challenge_id

LEFT JOIN (SELECT challenge_id,
        SUM(total_views) AS total_views,
        SUM(total_unique_views) AS total_unique_views
    FROM View_Stats
    GROUP BY challenge_id) vs
    ON ch.challenge_id = vs.challenge_id
GROUP BY c.contest_id, c.hacker_id,c.name
HAVING
       SUM(COALESCE(ss.total_submissions, 0)) <> 0
    OR SUM(COALESCE(ss.total_accepted_submissions, 0)) <> 0
    OR SUM(COALESCE(vs.total_views, 0)) <> 0
    OR SUM(COALESCE(vs.total_unique_views, 0)) <> 0

ORDER BY c.contest_id;

-- 11. Contest Leaderboard
SELECT h.hacker_id, h.name, scores.total_score
FROM Hackers h
JOIN (SELECT hacker_id, SUM(max_score) AS total_score
    FROM (SELECT hacker_id, challenge_id, MAX(score) AS max_score
        FROM Submissions
        GROUP BY
            hacker_id, challenge_id) x
    GROUP BY hacker_id
) scores
    ON h.hacker_id = scores.hacker_id
WHERE scores.total_score > 0
ORDER BY scores.total_score DESC, h.hacker_id ASC;

-- Leetcode
-- 12 Product sales analysis
SELECT p.product_name, s.year, s.price FROM Sales AS s
JOIN Product AS p
    ON s.product_id = p.product_id;

-- 13.  Customer Who Visited but Did Not Make Any Transactions
SELECT v.customer_id, COUNT(*) AS count_no_trans FROM Visits v
LEFT JOIN Transactions t
    ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY v.customer_id;

-- 14. Rising Temperature
SELECT w1.id FROM Weather w1
JOIN Weather w2
    ON DATEADD(day, 1, w2.recordDate) = w1.recordDate
WHERE w1.temperature > w2.temperature;

-- 15. Average Time of Process per Machine
SELECT a1.machine_id,
    ROUND(AVG(a2.timestamp - a1.timestamp), 3) AS processing_time
FROM Activity a1 JOIN Activity a2
    ON a1.machine_id = a2.machine_id
    AND a1.process_id = a2.process_id
WHERE a1.activity_type = 'start' AND a2.activity_type = 'end'
GROUP BY a1.machine_id;

-- 16. Employee Bonus
SELECT e.name, b.bonus
FROM Employee e
LEFT JOIN Bonus b
    ON e.empId = b.empId
WHERE b.bonus < 1000 OR b.bonus IS NULL;

-- 17. Students and Examinations
SELECT s.student_id, s.student_name, sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
    AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;

-- 18. Managers with at Least 5 Direct Reports
SELECT m.name FROM Employee m
JOIN Employee e
    ON m.id = e.managerId
GROUP BY m.id, m.name
HAVING COUNT(*) >= 5;


-- 19. Confirmation Rate
SELECT s.user_id,
    COALESCE(ROUND(1.0 * SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END)/ NULLIF(COUNT(c.action), 0),2), 0) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id;

-- 20. Department Top Three Salaries 
WITH RankedEmployees AS (SELECT id, name, salary, departmentId,
        DENSE_RANK() OVER (PARTITION BY departmentId
            ORDER BY salary DESC
        ) AS salary_rank
    FROM Employee)
SELECT d.name AS Department, r.name AS Employee, r.salary AS Salary
FROM RankedEmployees r
JOIN Department d
    ON r.departmentId = d.id
WHERE r.salary_rank <= 3;