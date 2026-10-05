/* Valid test 02:
   σύνθετες συνθήκες,τελεστές IN / NOT IN, GROUP BY, ORDER BY and LIMIT. */
CREATE TABLE Products (
    product_id int,
    product_name varchar(100),
    category varchar(40),
    price float,
    stock int,
    rating float,
    supplier varchar(60)
);

CREATE TABLE Categories (
    category_id int,
    category_name varchar(50),
    active int
);

CREATE TABLE Inventory (
    inventory_id int,
    warehouse varchar(40),
    quantity int,
    product_code int
);

SeLeCt product_id, product_name, category, price
FrOm Products
WhErE (price >= 10.5 AND category IN ('Books', 'Games', 'Office'))
   OR (stock > 20 AND rating >= 4.0)
OrDeR BY price, product_name
LiMiT 15;

SELECT product_id, supplier, stock
FROM Products
WHERE supplier NOT IN ('Unknown', 'Inactive')
  AND stock >= 0
GROUP BY product_id, supplier, stock
ORDER BY supplier, product_id;

SELECT category_id, category_name
FROM Categories
WHERE active = 1
ORDER BY category_name
LIMIT 30;

SELECT inventory_id, warehouse, quantity, product_code
FROM Inventory
WHERE quantity > 0 AND warehouse != 'Closed'
ORDER BY warehouse, quantity;
