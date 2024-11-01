DROP PROCEDURE IF EXISTS lowSugarCheck;
DELIMITER //

CREATE PROCEDURE lowSugarCheck (
    IN testPatient INT(10)
)
BEGIN
    IF testPatient IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM diabetes.medicalrecords
            WHERE PatientID = testPatient
              AND Sweating = 'YES'
              AND Shivering = 'YES'
        ) THEN
            SELECT BloodGlucose
            FROM diabetes.medicalrecords
            WHERE PatientID = testPatient
              AND Sweating = 'YES'
              AND Shivering = 'YES';
        ELSE
            SELECT 'This patient did not present Sweating and Shivering.' AS Message;
        END IF;
    ELSE
			SELECT 'No value entered for PatientID' AS Message;
    END IF;
END //

DELIMITER ;


# CALL diabetes.lowSugarCheck(null);

