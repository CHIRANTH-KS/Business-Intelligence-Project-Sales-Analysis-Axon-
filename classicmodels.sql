
# pending payment

WITH compiledorder AS (
    SELECT
        customerNumber,
        SUM(quantityOrdered * priceEach) AS orderamount
    FROM
        orderdetails
    INNER JOIN orders USING(orderNumber)
    GROUP BY
        customerNumber
)
SELECT
    o.orderNumber,
    o.customerNumber,
    c.customerName,
    co.orderamount,
    SUM(p.amount) AS payment_amount,
    (co.orderamount - SUM(p.amount)) AS pendingpayment
FROM
    payments p
INNER JOIN orders o USING (customerNumber)
INNER JOIN compiledorder co USING (customerNumber)
INNER JOIN customers c USING (customerNumber)
GROUP BY
    o.orderNumber,
    o.customerNumber
HAVING
    pendingpayment > 0;
    
    
    # Top selling products

SELECT p.productName, pl.productLine, SUM(od.quantityOrdered) AS totalQuantity
FROM orderdetails od
INNER JOIN products p ON od.productCode = p.productCode
INNER JOIN productlines pl ON p.productLine = pl.productLine
GROUP BY p.productCode
ORDER BY totalQuantity DESC
LIMIT 10;
