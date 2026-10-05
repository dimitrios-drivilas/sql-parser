/* Valid test 03: όλοι οι προιρετικοί τελεστές όπωσ π.χ. LIMIT, GROUP BY, ORDER BY κ.λ.π. και keyword με κεφαλαία και πεζά*/
CREATE TABLE Departments (
    department_id int,
    department_name varchar(70),
    campus varchar(50)
);

CREATE TABLE Courses (
    course_id int,
    title varchar(120),
    subject varchar(50),
    active int,
    hours float,
    semester int
);

CREATE TABLE Exams (
    exam_id int,
    course_code int,
    room varchar(20),
    score float,
    status varchar(20)
);

SELECT department_id, department_name, campus
FROM Departments
WHERE department_id > 0
ORDER BY department_name, campus;

SELECT course_id, title, subject, hours
FROM Courses
WHERE (active = 1 AND semester IN (1, 2, 3, 4, 5, 6, 7, 8))
   AND title NOT IN ('Cancelled', 'Archived')
GROUP BY course_id, title, subject, hours
ORDER BY subject, title
LIMIT 40;

-- Keyword με κεφαλαία
SELECT exam_id, course_code, room, score, status
FROM Exams
WHERE (score >= 5.0 OR status = 'pending')
  AND status NOT IN ('cancelled', 'deleted')
GROUP BY exam_id, course_code, room, score, status
ORDER BY score, exam_id
LIMIT 50;

-- Keyword με πεζά
select course_id, title
from Courses
where active = 1
order by course_id
limit 5;
