-- transactions.sql
-- DMV Database Design and Transaction Management Project
-- T1-T6 transaction pack
--

--


USE dmv_project;

DELIMITER $$

-- =========================================================
-- T1. Register a new vehicle and its first ownership record.
-- =========================================================
DROP PROCEDURE IF EXISTS T1_RegisterVehicle$$

CREATE PROCEDURE T1_RegisterVehicle(
    IN p_TypeCode VARCHAR(20),
    IN p_YearNumber SMALLINT,
    IN p_MakeCode VARCHAR(30),
    IN p_ModelName VARCHAR(50),
    IN p_VIN VARCHAR(17),
    IN p_PlateID VARCHAR(15),
    IN p_StateCode CHAR(2),
    IN p_RegistrationDate DATE,
    IN p_RegistrationExpirationDate DATE,
    IN p_OwnerPersonNumber INT,
    IN p_OwnershipStartDate DATE
)
BEGIN
    DECLARE v_NewVehicleID INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Vehicle (
        TypeCode,
        YearNumber,
        MakeCode,
        ModelName,
        VIN,
        PlateID,
        StateCode,
        RegistrationDate,
        RegistrationExpirationDate
    )
    VALUES (
        p_TypeCode,
        p_YearNumber,
        p_MakeCode,
        p_ModelName,
        p_VIN,
        p_PlateID,
        p_StateCode,
        p_RegistrationDate,
        p_RegistrationExpirationDate
    );

    SET v_NewVehicleID = LAST_INSERT_ID();

    INSERT INTO VehicleOwner (
        VehicleID,
        PersonNumber,
        StartDate,
        EndDate,
        OwnershipPercent
    )
    VALUES (
        v_NewVehicleID,
        p_OwnerPersonNumber,
        p_OwnershipStartDate,
        NULL,
        100.00
    );

    COMMIT;

    SELECT
        v.VehicleID,
        v.VIN,
        v.PlateID,
        p.FullName AS OwnerName,
        vo.StartDate
    FROM Vehicle AS v
    JOIN VehicleOwner AS vo
        ON vo.VehicleID = v.VehicleID
       AND vo.EndDate IS NULL
    JOIN Person AS p
        ON p.PersonNumber = vo.PersonNumber
    WHERE v.VehicleID = v_NewVehicleID;
END$$


-- =========================================================
-- T2. Transfer current vehicle ownership to another person.
-- SELECT ... FOR UPDATE prevents simultaneous transfers.
-- =========================================================
DROP PROCEDURE IF EXISTS T2_TransferVehicleOwnership$$

CREATE PROCEDURE T2_TransferVehicleOwnership(
    IN p_VehicleID INT,
    IN p_NewOwnerPersonNumber INT,
    IN p_TransferDate DATE
)
BEGIN
    DECLARE v_CurrentOwnerPersonNumber INT DEFAULT NULL;
    DECLARE v_CurrentStartDate DATE DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT
        PersonNumber,
        StartDate
    INTO
        v_CurrentOwnerPersonNumber,
        v_CurrentStartDate
    FROM VehicleOwner
    WHERE VehicleID = p_VehicleID
      AND EndDate IS NULL
    ORDER BY StartDate DESC
    LIMIT 1
    FOR UPDATE;

    IF v_CurrentOwnerPersonNumber IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transfer failed: vehicle has no current owner.';
    END IF;

    IF v_CurrentOwnerPersonNumber = p_NewOwnerPersonNumber THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transfer failed: new owner is already the current owner.';
    END IF;

    IF p_TransferDate <= v_CurrentStartDate THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Transfer failed: transfer date must be after current ownership start date.';
    END IF;

    UPDATE VehicleOwner
    SET EndDate = DATE_SUB(p_TransferDate, INTERVAL 1 DAY)
    WHERE VehicleID = p_VehicleID
      AND PersonNumber = v_CurrentOwnerPersonNumber
      AND StartDate = v_CurrentStartDate;

    INSERT INTO VehicleOwner (
        VehicleID,
        PersonNumber,
        StartDate,
        EndDate,
        OwnershipPercent
    )
    VALUES (
        p_VehicleID,
        p_NewOwnerPersonNumber,
        p_TransferDate,
        NULL,
        100.00
    );

    COMMIT;

    SELECT
        vo.VehicleID,
        p.FullName AS OwnerName,
        vo.StartDate,
        vo.EndDate,
        CASE
            WHEN vo.EndDate IS NULL THEN 'CURRENT'
            ELSE 'FORMER'
        END AS OwnershipStatus
    FROM VehicleOwner AS vo
    JOIN Person AS p
        ON p.PersonNumber = vo.PersonNumber
    WHERE vo.VehicleID = p_VehicleID
    ORDER BY vo.StartDate;
END$$


-- =========================================================
-- T3. Record a citation and link it to a vehicle and traffic code.
-- =========================================================
DROP PROCEDURE IF EXISTS T3_RecordCitation$$

CREATE PROCEDURE T3_RecordCitation(
    IN p_EventDateTime DATETIME,
    IN p_LocationDesc VARCHAR(200),
    IN p_ReportDesc TEXT,
    IN p_ReportOfficerNumber INT,
    IN p_CitedPersonNumber INT,
    IN p_VehicleID INT,
    IN p_TrafficCodeID INT,
    IN p_FineAmount DECIMAL(10,2),
    IN p_DueDate DATE,
    IN p_CourtName VARCHAR(100)
)
BEGIN
    DECLARE v_NewEventNumber INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Event (
        EventDateTime,
        LocationDesc,
        ReportDesc,
        EventCode,
        CauseEventNumber,
        ReportOfficerNumber
    )
    VALUES (
        p_EventDateTime,
        p_LocationDesc,
        p_ReportDesc,
        'C',
        NULL,
        p_ReportOfficerNumber
    );

    SET v_NewEventNumber = LAST_INSERT_ID();

    INSERT INTO Citation (
        EventNumber,
        CitedPersonNumber,
        FineAmount,
        DueDate,
        CitationStatusCode,
        CourtName
    )
    VALUES (
        v_NewEventNumber,
        p_CitedPersonNumber,
        p_FineAmount,
        p_DueDate,
        'OPEN',
        p_CourtName
    );

    INSERT INTO CitationTrafficCode (
        EventNumber,
        TrafficCodeID
    )
    VALUES (
        v_NewEventNumber,
        p_TrafficCodeID
    );

    INSERT INTO PersonEvent (
        PersonNumber,
        EventNumber,
        PersonRoleCode,
        InjuryFlag
    )
    VALUES (
        p_CitedPersonNumber,
        v_NewEventNumber,
        'DRIVER',
        FALSE
    );

    INSERT INTO VehicleEvent (
        VehicleID,
        EventNumber,
        VehicleRoleCode,
        DamageDesc
    )
    VALUES (
        p_VehicleID,
        v_NewEventNumber,
        'INVOLVED',
        'Vehicle associated with traffic stop; no collision damage.'
    );

    COMMIT;

    SELECT
        e.EventNumber,
        e.EventDateTime,
        p.FullName AS CitedPerson,
        v.PlateID,
        tc.SectionCode,
        c.FineAmount,
        c.CitationStatusCode
    FROM Event AS e
    JOIN Citation AS c
        ON c.EventNumber = e.EventNumber
    JOIN Person AS p
        ON p.PersonNumber = c.CitedPersonNumber
    JOIN CitationTrafficCode AS ctc
        ON ctc.EventNumber = c.EventNumber
    JOIN TrafficCode AS tc
        ON tc.TrafficCodeID = ctc.TrafficCodeID
    JOIN VehicleEvent AS ve
        ON ve.EventNumber = e.EventNumber
    JOIN Vehicle AS v
        ON v.VehicleID = ve.VehicleID
    WHERE e.EventNumber = v_NewEventNumber;
END$$


-- =========================================================
-- T4. Record an accident caused by an existing citation.
-- The cause must be an existing citation event.
-- =========================================================
DROP PROCEDURE IF EXISTS T4_RecordCitationCausedAccident$$

CREATE PROCEDURE T4_RecordCitationCausedAccident(
    IN p_EventDateTime DATETIME,
    IN p_LocationDesc VARCHAR(200),
    IN p_ReportDesc TEXT,
    IN p_ReportOfficerNumber INT,
    IN p_CauseCitationEventNumber INT,
    IN p_VehicleID INT,
    IN p_DriverPersonNumber INT,
    IN p_SeverityCode VARCHAR(15),
    IN p_InjuryCount INT,
    IN p_FatalityCount INT,
    IN p_EstimatedDamageAmount DECIMAL(12,2),
    IN p_WeatherCode VARCHAR(20),
    IN p_RoadConditionCode VARCHAR(20)
)
BEGIN
    DECLARE v_NewEventNumber INT;
    DECLARE v_CauseEventCode CHAR(1);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT EventCode
    INTO v_CauseEventCode
    FROM Event
    WHERE EventNumber = p_CauseCitationEventNumber
    FOR UPDATE;

    IF v_CauseEventCode IS NULL OR v_CauseEventCode <> 'C' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Accident cause must be an existing citation event.';
    END IF;

    INSERT INTO Event (
        EventDateTime,
        LocationDesc,
        ReportDesc,
        EventCode,
        CauseEventNumber,
        ReportOfficerNumber
    )
    VALUES (
        p_EventDateTime,
        p_LocationDesc,
        p_ReportDesc,
        'A',
        p_CauseCitationEventNumber,
        p_ReportOfficerNumber
    );

    SET v_NewEventNumber = LAST_INSERT_ID();

    INSERT INTO Accident (
        EventNumber,
        SeverityCode,
        InjuryCount,
        FatalityCount,
        EstimatedDamageAmount,
        WeatherCode,
        RoadConditionCode
    )
    VALUES (
        v_NewEventNumber,
        p_SeverityCode,
        p_InjuryCount,
        p_FatalityCount,
        p_EstimatedDamageAmount,
        p_WeatherCode,
        p_RoadConditionCode
    );

    INSERT INTO VehicleEvent (
        VehicleID,
        EventNumber,
        VehicleRoleCode,
        DamageDesc
    )
    VALUES (
        p_VehicleID,
        v_NewEventNumber,
        'AT_FAULT',
        'Damage documented during accident investigation.'
    );

    INSERT INTO PersonEvent (
        PersonNumber,
        EventNumber,
        PersonRoleCode,
        InjuryFlag
    )
    VALUES (
        p_DriverPersonNumber,
        v_NewEventNumber,
        'DRIVER',
        CASE WHEN p_InjuryCount > 0 THEN TRUE ELSE FALSE END
    );

    COMMIT;

    SELECT
        accident_event.EventNumber AS AccidentEventNumber,
        accident_event.EventDateTime AS AccidentDateTime,
        accident_event.CauseEventNumber AS CauseCitationEventNumber,
        citation_event.EventDateTime AS CitationDateTime,
        a.SeverityCode,
        a.InjuryCount,
        a.EstimatedDamageAmount
    FROM Event AS accident_event
    JOIN Accident AS a
        ON a.EventNumber = accident_event.EventNumber
    JOIN Event AS citation_event
        ON citation_event.EventNumber = accident_event.CauseEventNumber
    WHERE accident_event.EventNumber = v_NewEventNumber;
END$$


-- =========================================================
-- T5. Insert an exam and three exam parts.
-- =========================================================
DROP PROCEDURE IF EXISTS T5_RecordExam$$

CREATE PROCEDURE T5_RecordExam(
    IN p_PersonNumber INT,
    IN p_ExamDateTime DATETIME,
    IN p_CenterName VARCHAR(100),
    IN p_AdminOfficerNumber INT,
    IN p_WrittenScore DECIMAL(5,2),
    IN p_RoadSignsScore DECIMAL(5,2),
    IN p_RoadTestScore DECIMAL(5,2)
)
BEGIN
    DECLARE v_NewExamID INT;
    DECLARE v_OverallScore DECIMAL(5,2);
    DECLARE v_PassedFlag BOOLEAN;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF p_WrittenScore NOT BETWEEN 0 AND 100
       OR p_RoadSignsScore NOT BETWEEN 0 AND 100
       OR p_RoadTestScore NOT BETWEEN 0 AND 100 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exam rollback: every part score must be between 0 and 100.';
    END IF;

    SET v_OverallScore =
        ROUND((p_WrittenScore + p_RoadSignsScore + p_RoadTestScore) / 3, 2);

    SET v_PassedFlag =
        CASE
            WHEN v_OverallScore >= 70
             AND p_RoadTestScore >= 70
            THEN TRUE
            ELSE FALSE
        END;

    INSERT INTO Exam (
        PersonNumber,
        ExamDateTime,
        CenterName,
        AdminOfficerNumber,
        OverallScore,
        PassedFlag
    )
    VALUES (
        p_PersonNumber,
        p_ExamDateTime,
        p_CenterName,
        p_AdminOfficerNumber,
        v_OverallScore,
        v_PassedFlag
    );

    SET v_NewExamID = LAST_INSERT_ID();

    INSERT INTO ExamPart (
        ExamID,
        PartCode,
        PartScore,
        MaxScore
    )
    VALUES
        (v_NewExamID, 'WRITTEN', p_WrittenScore, 100.00),
        (v_NewExamID, 'ROAD_SIGNS', p_RoadSignsScore, 100.00),
        (v_NewExamID, 'ROAD_TEST', p_RoadTestScore, 100.00);

    COMMIT;

    SELECT
        ex.ExamID,
        p.FullName,
        ex.ExamDateTime,
        ex.OverallScore,
        ex.PassedFlag,
        ep.PartCode,
        ep.PartScore
    FROM Exam AS ex
    JOIN Person AS p
        ON p.PersonNumber = ex.PersonNumber
    JOIN ExamPart AS ep
        ON ep.ExamID = ex.ExamID
    WHERE ex.ExamID = v_NewExamID
    ORDER BY ep.PartCode;
END$$

DELIMITER ;

SELECT COUNT(*) FROM Exam;

CALL T5_RecordExam(
    1,
    NOW(),
    'Capital Region DMV Testing Center',
    1,
    85,
    125,
    88
);

SELECT COUNT(*) FROM Exam;
-- =========================================================
-- T6: CONCURRENCY CONTROL DEMONSTRATION
-- =========================================================


-- =========================================================
-- SESSION A
-- Locks the current ownership row for VehicleID 30.
-- Do not commit immediately.
-- =========================================================

START TRANSACTION;

SELECT VehicleID,
       PersonNumber,
       StartDate,
       EndDate,
       OwnershipPercent
FROM VehicleOwner
WHERE VehicleID = 30
  AND EndDate IS NULL
FOR UPDATE;


COMMIT;


-- =========================================================
-- SESSION B

-- =========================================================

START TRANSACTION;

SELECT VehicleID,
       PersonNumber,
       StartDate,
       EndDate,
       OwnershipPercent
FROM VehicleOwner
WHERE VehicleID = 30
  AND EndDate IS NULL
FOR UPDATE;


COMMIT;

-- BEFORE
SELECT COUNT(*) FROM Vehicle;

CALL T1_RegisterVehicle('SEDAN', 2026, 'Honda', 'Civic', '1HGDEMO000000001',
    'TEST01', 'NY', '2026-07-24', '2028-07-24', 1, '2026-07-24');

-- AFTER
SELECT COUNT(*) FROM Vehicle;
-- BEFORE
SELECT * FROM CurrentVehicleOwnership WHERE VehicleID = 1;

CALL T2_TransferVehicleOwnership(1, 2, '2026-07-24');

-- AFTER
SELECT * FROM CurrentVehicleOwnership WHERE VehicleID = 1;
SELECT COUNT(*) FROM Citation;

CALL T3_RecordCitation(NOW(), 'Test Location', 'Test stop', 1, 1, 1, 1, 150.00, '2026-09-01', 'Albany County Traffic Court');

SELECT COUNT(*) FROM Citation;
SELECT COUNT(*) FROM Accident;

CALL T4_RecordCitationCausedAccident(NOW(), 'Test Location', 'Test accident', 1, 1, 1, 1,
    'MINOR', 0, 0, 1500.00, 'CLEAR', 'DRY');

SELECT COUNT(*) FROM Accident;


SELECT COUNT(*) FROM Exam;
CALL T5_RecordExam(1, NOW(), 'Capital Region DMV Testing Center', 1, 85, 90, 88);
SELECT COUNT(*) FROM Exam;