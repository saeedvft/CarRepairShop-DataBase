DELIMITER $$

CREATE TRIGGER UpdateMileageAfterService
AFTER INSERT ON Schedule
FOR EACH ROW
BEGIN
    -- Update the mileage of the vehicle by adding 500 after a service is completed
    UPDATE Vehicle
    SET mileage = mileage + 500
    WHERE id = NEW.vehicle_id;
    INSERT INTO log_table (log_time, action, details)
	VALUES (NOW(), 'Trigger Fired', 'Update the mileage of the vehicle by adding 500 after a service is completed');
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS UpdateMileageAfterService;

INSERT INTO Schedule (schedule_date, technician_id, vehicle_id, task_id)
VALUES ('2025-01-10 10:00:00', 4, 2, 3);