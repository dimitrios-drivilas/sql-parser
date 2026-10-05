-- Invalid test 03: χρησιμοποίηση πίνακα που δεν δημιουργηθεί στο from
CREATE TABLE Students (
    student_id int,
    full_name varchar(80),
    grade float
);

CREATE TABLE Courses (
    course_id int,
    title varchar(100),
    active int
);

SELECT student_id, full_name
FROM Students
WHERE grade >= 5.0
ORDER BY full_name;

SELECT course_id, title
FROM Courses
WHERE active = 1
ORDER BY course_id;

-- ERROR: O πίνακας MissingTable δεν έχει δημιουργηθεί προηγουμένως
SELECT item_id, item_name
FROM MissingTable
WHERE item_id > 0;
