-- Invalid test 07: Ο τελεστής ORDER BY χρησιμοποιεί στήλη που δεν έχει οριστεί στον πίνακα Tickets.
CREATE TABLE Tickets (
    ticket_id int,
    priority int,
    status varchar(20),
    owner varchar(60),
    category varchar(30)
);

CREATE TABLE Agents (
    agent_id int,
    agent_name varchar(70),
    active int
);

SELECT agent_id, agent_name
FROM Agents
WHERE active = 1
ORDER BY agent_name;

SELECT ticket_id, priority, status, owner
FROM Tickets
WHERE status NOT IN ('closed', 'deleted')
GROUP BY ticket_id, priority, status, owner
ORDER BY priority, ticket_id;

-- ERROR: το πεδίο created_at δεν έχει οριστεί στον πίνακα Tickets.
SELECT ticket_id, status, category
FROM Tickets
WHERE priority >= 1
ORDER BY created_at, ticket_id;
