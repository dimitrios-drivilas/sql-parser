-- Invalid test 10: Το μήκος του VARCHAR πρέπει να είναι θετικό
CREATE TABLE Users (
    user_id int,
    username varchar(50),
    age int,
    active int
);

SELECT user_id, username
FROM Users
WHERE active = 1 AND age >= 18
ORDER BY username;

CREATE TABLE Settings (
    setting_id int,
    setting_name varchar(80),
    enabled int
);

SELECT setting_id, setting_name
FROM Settings
WHERE enabled = 1
ORDER BY setting_name;

-- ERROR: varchar(0) δεν είναι επιτρεπτό.
CREATE TABLE Profiles (
    profile_id int,
    nickname varchar(0),
    city varchar(40),
    score float
);
