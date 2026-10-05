-- Invalid test 09: Στην τελευταία εντολή SELECT λείπει το ;
CREATE TABLE Warehouses (
    warehouse_id int,
    city varchar(40),
    capacity int,
    active int
);

CREATE TABLE Shipments (
    shipment_id int,
    warehouse_code int,
    quantity int,
    status varchar(20)
);

SELECT warehouse_id, city, capacity
FROM Warehouses
WHERE active = 1 AND capacity > 0
ORDER BY city;

SELECT shipment_id, warehouse_code, quantity
FROM Shipments
WHERE status IN ('ready', 'sent')
ORDER BY shipment_id
LIMIT 100;

-- ERROR: δεν υπάρχει το σύμβολο ; στο τέλος αυτής της εντολής SELECT.
SELECT warehouse_id, city
FROM Warehouses
WHERE capacity >= 500
ORDER BY warehouse_id
