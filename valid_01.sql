-- Valid test 01: διαφορετικοί πίνακες και πολλαπλές εντολές SELECT.
CREATE TABLE Students (
    student_id int,
    full_name varchar(80),
    age int,
    grade float,
    city varchar(40),
    active int
);

CREATE TABLE Departments (
    department_id int,
    department_name varchar(70),
    building varchar(30),
    active int
);

CREATE TABLE Registrations (
    registration_id int,
    student_code int,
    semester int,
    status varchar(20)
);

SELECT *
FROM Students;

SELECT student_id, full_name, age, grade
FROM Students
WHERE age >= 18 AND grade >= 5.0
ORDER BY grade, full_name
LIMIT 25;

SELECT department_id, department_name, building
FROM Departments
WHERE active = 1
GROUP BY department_id, department_name, building
ORDER BY department_name
LIMIT 10;

SELECT registration_id, student_code, semester, status
FROM Registrations
WHERE status IN ('active', 'pending', 'completed')
  AND semester >= 1
ORDER BY semester, registration_id;
