-- Invalid test 04: Η εντολή SELECT χρησιμοποιεί στήλη που δεν έχει οριστεί στον πίνακα Movies.
CREATE TABLE Movies (
    movie_id int,
    title varchar(100),
    year_released int,
    rating float,
    category varchar(40)
);

CREATE TABLE Cinemas (
    cinema_id int,
    cinema_name varchar(80),
    city varchar(40)
);

SELECT cinema_id, cinema_name, city
FROM Cinemas
ORDER BY cinema_name;

SELECT movie_id, title, rating
FROM Movies
WHERE rating >= 7.0
ORDER BY rating;

-- ERROR: το πεδίο director δεν είναι στήλη του πίνακα Movies.
SELECT movie_id, title, director, category
FROM Movies;
