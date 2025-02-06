DELIMITER $$

CREATE PROCEDURE AddScheduleEntry(
    IN p_schedule_date DATETIME,
    IN p_technician_id INT,
    IN p_vehicle_id INT,
    IN p_task_id INT
)
BEGIN
    -- Insert a new schedule entry
    INSERT INTO schedule (schedule_date, technician_id, vehicle_id, task_id)
    VALUES (p_schedule_date, p_technician_id, p_vehicle_id, p_task_id);

    -- Log the action (assuming there's a log table)
    INSERT INTO log_table (log_time, action, details)
    VALUES (NOW(), 'Add Schedule', CONCAT('New schedule added for Technician ID: ', p_technician_id, ', Vehicle ID: ', p_vehicle_id));
END$$

DELIMITER ;

CALL AddScheduleEntry('2025-01-10 10:00:00', 1, 2, 3);

