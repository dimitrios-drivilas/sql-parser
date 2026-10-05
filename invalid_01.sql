-- Invalid test 01: διπλό όνομα πίνακα 
CREATE TABLE Users (
    user_id int,
    username varchar(50),
    active int
);

CREATE TABLE Rooms (
    room_id int,
    room_name varchar(40),
    capacity int
);

SELECT user_id, username
FROM Users
WHERE active = 1
ORDER BY username;

SELECT room_id, room_name, capacity
FROM Rooms
WHERE capacity > 0
ORDER BY room_id;

-- ERROR: O πίνακας Rooms έχει ήδη δημιουργηθεί παραπάνω.
CREATE TABLE Rooms (
    code varchar(10),
    floor int,
    available int
);
