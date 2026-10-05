-- Invalid test 08: εντολή SELECT με λανθασμένη σειρά των όρων ORDER BY και GROUP BY
CREATE TABLE Logs (
    log_id int,
    category varchar(20),
    severity int,
    message varchar(120)
);

CREATE TABLE Servers (
    server_id int,
    server_name varchar(50),
    active int
);

SELECT server_id, server_name
FROM Servers
WHERE active = 1
ORDER BY server_name;

SELECT log_id, category, severity
FROM Logs
WHERE severity >= 2
GROUP BY log_id, category, severity
ORDER BY severity;

-- ERROR: ο τελεστής GROUP BY εμφανίζεται μετά από τον τελεστή ORDER BY.
SELECT category, severity
FROM Logs
WHERE severity > 0
ORDER BY category
GROUP BY category, severity;
