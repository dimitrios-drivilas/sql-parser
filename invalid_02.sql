-- Invalid test 02: διπλότυπο όνομα στήλης σε CREATE TABLE.
CREATE TABLE Warehouses (
    warehouse_id int,
    city varchar(40),
    capacity int
);

SELECT warehouse_id, city
FROM Warehouses
WHERE capacity > 100
ORDER BY city;

CREATE TABLE Devices (
    device_id int,
    serial varchar(30),
    model varchar(50),
    price float,
    active int,
    -- ERROR: το πεδίο device_id δηλώνεται για δεύτερη φορά.
    device_id int
);
