-- Invalid test 06: Ο τελεστή GROUP BY χρησιμοποιεί άγνωστη στήλη.
CREATE TABLE Sales (
    sale_id int,
    amount float,
    region varchar(30),
    category varchar(40),
    completed int
);

CREATE TABLE Offices (
    office_id int,
    office_name varchar(60),
    region varchar(30)
);

SELECT office_id, office_name, region
FROM Offices
WHERE office_id > 0
ORDER BY region, office_name;

SELECT region, category, amount
FROM Sales
WHERE completed = 1 AND amount > 0.0
ORDER BY region;

-- ERROR: το πεδίο salesperson δεν έχει οριστεί στον πίνακα Sales.
SELECT region, category
FROM Sales
WHERE completed = 1
GROUP BY region, category, salesperson
ORDER BY region, category;
