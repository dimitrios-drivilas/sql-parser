-- Invalid test 05: ο τελεστής WHERE χρησιμοποιεί άγνωστη στήλη.
CREATE TABLE Accounts (
    account_id int,
    owner varchar(80),
    account_type varchar(30),
    active int
);

CREATE TABLE Branches (
    branch_id int,
    branch_name varchar(70),
    city varchar(40)
);

SELECT branch_id, branch_name
FROM Branches
WHERE city IN ('Patras', 'Athens')
ORDER BY branch_name;

SELECT account_id, owner, account_type
FROM Accounts
WHERE active = 1
ORDER BY owner;

-- ERROR: το πεδίο balance δεν έχει οριστεί στον πίνακα Accounts.
SELECT account_id, owner
FROM Accounts
WHERE balance > 1000 AND active = 1;
