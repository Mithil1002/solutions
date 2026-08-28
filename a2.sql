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
