DELIMITER $$

CREATE FUNCTION GetCustomerTotalCost(customerID INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalCost DECIMAL(10, 2);

    -- Calculate the total cost of invoices for the specified customer
    SELECT SUM(i.total_price) -- Adjusted column name to fit your schema
    INTO totalCost
    FROM invoice i            -- Adjusted table name to fit your schema
    WHERE i.customer_id = customerID; -- Adjusted column name to fit your schema

    -- Return the total cost, or 0 if no invoices exist
    RETURN IFNULL(totalCost, 0);
END$$

DELIMITER ;

SELECT GetCustomerTotalCost(3); -- Replace '1' with the desired CustomerID