-- DMV Database Design and Transaction Management Project


DROP DATABASE IF EXISTS dmv_project;
CREATE DATABASE dmv_project
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;
USE dmv_project;

-- 1. PERSON
CREATE TABLE Person (
    PersonNumber INT AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    BirthDate DATE NOT NULL,
    SexCode CHAR(1),
    PhoneNumber VARCHAR(20),
    EmailAddress VARCHAR(120),
    CONSTRAINT pk_person PRIMARY KEY (PersonNumber),
    CONSTRAINT uq_person_email UNIQUE (EmailAddress),
    CONSTRAINT chk_person_sex CHECK (SexCode IN ('M', 'F', 'X'))
) ENGINE = InnoDB;

-- 2. ADDRESS: weak/dependent entity; one address per person
CREATE TABLE Address (
    PersonNumber INT,
    Street1Desc VARCHAR(120) NOT NULL,
    Street2Desc VARCHAR(120),
    CityName VARCHAR(60) NOT NULL,
    StateCode CHAR(2) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL,
    CONSTRAINT pk_address PRIMARY KEY (PersonNumber),
    CONSTRAINT fk_address_person
        FOREIGN KEY (PersonNumber)
        REFERENCES Person(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

-- 3. LICENSE
CREATE TABLE License (
    LicenseID VARCHAR(20) NOT NULL,
    StateCode CHAR(2) NOT NULL,
    IssueDate DATE NOT NULL,
    ExpirationDate DATE NOT NULL,
    LicenseStatusCode VARCHAR(12) NOT NULL DEFAULT 'ACTIVE',
    NCFlag BOOLEAN NOT NULL DEFAULT FALSE,
    MFlag BOOLEAN NOT NULL DEFAULT FALSE,
    CFFlag BOOLEAN NOT NULL DEFAULT FALSE,
    CPFlag BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_license PRIMARY KEY (LicenseID, StateCode),
    CONSTRAINT chk_license_dates CHECK (ExpirationDate >= IssueDate),
    CONSTRAINT chk_license_status
        CHECK (LicenseStatusCode IN ('ACTIVE', 'EXPIRED', 'SUSPENDED', 'REVOKED'))
) ENGINE = InnoDB;

-- 4. OPERATOR: role/subtype of Person
CREATE TABLE Operator (
    PersonNumber INT,
    EyeGlassFlag BOOLEAN NOT NULL DEFAULT FALSE,
    HairColorCode VARCHAR(10),
    EyeColorCode VARCHAR(10),
    OperatorLicenseID VARCHAR(20),
    OperatorLicenseState CHAR(2),
    CONSTRAINT pk_operator PRIMARY KEY (PersonNumber),
    CONSTRAINT uq_operator_license UNIQUE (OperatorLicenseID, OperatorLicenseState),
    CONSTRAINT fk_operator_person
        FOREIGN KEY (PersonNumber)
        REFERENCES Person(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_operator_license
        FOREIGN KEY (OperatorLicenseID, OperatorLicenseState)
        REFERENCES License(LicenseID, StateCode)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = InnoDB;

-- 5. OFFICER
CREATE TABLE Officer (
    OfficerNumber INT AUTO_INCREMENT,
    BadgeNumber VARCHAR(20) NOT NULL,
    DepartmentCode VARCHAR(20) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    RankCode VARCHAR(20),
    ActiveFlag BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_officer PRIMARY KEY (OfficerNumber),
    CONSTRAINT uq_officer_badge UNIQUE (BadgeNumber)
) ENGINE = InnoDB;

-- 6. VEHICLE
CREATE TABLE Vehicle (
    VehicleID INT AUTO_INCREMENT,
    TypeCode VARCHAR(20) NOT NULL,
    YearNumber SMALLINT NOT NULL,
    MakeCode VARCHAR(30) NOT NULL,
    ModelName VARCHAR(50) NOT NULL,
    VIN VARCHAR(17) NOT NULL,
    PlateID VARCHAR(15),
    StateCode CHAR(2),
    RegistrationDate DATE,
    RegistrationExpirationDate DATE,
    CONSTRAINT pk_vehicle PRIMARY KEY (VehicleID),
    CONSTRAINT uq_vehicle_vin UNIQUE (VIN),
    CONSTRAINT uq_vehicle_plate UNIQUE (PlateID, StateCode),
    CONSTRAINT chk_vehicle_year CHECK (YearNumber BETWEEN 1900 AND 2100),
    CONSTRAINT chk_vehicle_registration_dates
        CHECK (
            RegistrationExpirationDate IS NULL
            OR RegistrationDate IS NULL
            OR RegistrationExpirationDate >= RegistrationDate
        )
) ENGINE = InnoDB;

-- 7. VEHICLE OWNER: associative entity supporting ownership history
CREATE TABLE VehicleOwner (
    VehicleID INT NOT NULL,
    PersonNumber INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE,
    OwnershipPercent DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    CONSTRAINT pk_vehicle_owner
        PRIMARY KEY (VehicleID, PersonNumber, StartDate),
    CONSTRAINT fk_vehicleowner_vehicle
        FOREIGN KEY (VehicleID)
        REFERENCES Vehicle(VehicleID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_vehicleowner_person
        FOREIGN KEY (PersonNumber)
        REFERENCES Person(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_vehicleowner_dates
        CHECK (EndDate IS NULL OR EndDate >= StartDate),
    CONSTRAINT chk_vehicleowner_percent
        CHECK (OwnershipPercent > 0 AND OwnershipPercent <= 100)
) ENGINE = InnoDB;

-- 8. EVENT SUPERTYPE
CREATE TABLE Event (
    EventNumber INT AUTO_INCREMENT,
    EventDateTime DATETIME NOT NULL,
    LocationDesc VARCHAR(200) NOT NULL,
    ReportDesc TEXT,
    EventCode CHAR(1) NOT NULL,
    CauseEventNumber INT,
    ReportOfficerNumber INT NOT NULL,

    CONSTRAINT pk_event
        PRIMARY KEY (EventNumber),

    CONSTRAINT chk_event_code
        CHECK (EventCode IN ('A', 'C')),

    CONSTRAINT fk_event_cause
        FOREIGN KEY (CauseEventNumber)
        REFERENCES Event(EventNumber)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_event_officer
        FOREIGN KEY (ReportOfficerNumber)
        REFERENCES Officer(OfficerNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 9. ACCIDENT SUBTYPE
CREATE TABLE Accident (
    EventNumber INT,
    SeverityCode VARCHAR(15) NOT NULL,
    InjuryCount INT NOT NULL DEFAULT 0,
    FatalityCount INT NOT NULL DEFAULT 0,
    EstimatedDamageAmount DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    WeatherCode VARCHAR(20),
    RoadConditionCode VARCHAR(20),
    CONSTRAINT pk_accident PRIMARY KEY (EventNumber),
    CONSTRAINT fk_accident_event
        FOREIGN KEY (EventNumber)
        REFERENCES Event(EventNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_accident_severity
        CHECK (SeverityCode IN ('MINOR', 'MODERATE', 'SEVERE', 'FATAL')),
    CONSTRAINT chk_accident_injuries CHECK (InjuryCount >= 0),
    CONSTRAINT chk_accident_fatalities CHECK (FatalityCount >= 0),
    CONSTRAINT chk_accident_damage CHECK (EstimatedDamageAmount >= 0)
) ENGINE = InnoDB;

-- 10. CITATION SUBTYPE
CREATE TABLE Citation (
    EventNumber INT,
    CitedPersonNumber INT NOT NULL,
    FineAmount DECIMAL(10,2) NOT NULL,
    DueDate DATE NOT NULL,
    CitationStatusCode VARCHAR(15) NOT NULL DEFAULT 'OPEN',
    CourtName VARCHAR(100),
    CONSTRAINT pk_citation PRIMARY KEY (EventNumber),
    CONSTRAINT fk_citation_event
        FOREIGN KEY (EventNumber)
        REFERENCES Event(EventNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_citation_person
        FOREIGN KEY (CitedPersonNumber)
        REFERENCES Person(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_citation_fine CHECK (FineAmount >= 0),
    CONSTRAINT chk_citation_status
        CHECK (CitationStatusCode IN ('OPEN', 'PAID', 'DISMISSED', 'OVERDUE'))
) ENGINE = InnoDB;

-- 11. TRAFFIC CODE LOOKUP
CREATE TABLE TrafficCode (
    TrafficCodeID INT AUTO_INCREMENT,
    SectionCode VARCHAR(20) NOT NULL,
    CodeDesc VARCHAR(255) NOT NULL,
    DefaultFineAmount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    PointNumber SMALLINT NOT NULL DEFAULT 0,
    CONSTRAINT pk_traffic_code PRIMARY KEY (TrafficCodeID),
    CONSTRAINT uq_traffic_section UNIQUE (SectionCode),
    CONSTRAINT chk_traffic_default_fine CHECK (DefaultFineAmount >= 0),
    CONSTRAINT chk_traffic_points CHECK (PointNumber >= 0)
) ENGINE = InnoDB;

-- 12. CITATION-TRAFFIC CODE BRIDGE
CREATE TABLE CitationTrafficCode (
    EventNumber INT NOT NULL,
    TrafficCodeID INT NOT NULL,
    CONSTRAINT pk_citation_traffic_code
        PRIMARY KEY (EventNumber, TrafficCodeID),
    CONSTRAINT fk_ctc_citation
        FOREIGN KEY (EventNumber)
        REFERENCES Citation(EventNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_ctc_traffic_code
        FOREIGN KEY (TrafficCodeID)
        REFERENCES TrafficCode(TrafficCodeID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB;

-- 13. VEHICLE-EVENT BRIDGE
CREATE TABLE VehicleEvent (
    VehicleID INT NOT NULL,
    EventNumber INT NOT NULL,
    VehicleRoleCode VARCHAR(20) NOT NULL DEFAULT 'INVOLVED',
    DamageDesc VARCHAR(255),
    CONSTRAINT pk_vehicle_event PRIMARY KEY (VehicleID, EventNumber),
    CONSTRAINT fk_vehicleevent_vehicle
        FOREIGN KEY (VehicleID)
        REFERENCES Vehicle(VehicleID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_vehicleevent_event
        FOREIGN KEY (EventNumber)
        REFERENCES Event(EventNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_vehicle_role
        CHECK (VehicleRoleCode IN ('AT_FAULT', 'VICTIM', 'WITNESS', 'INVOLVED'))
) ENGINE = InnoDB;

-- 14. PERSON-EVENT BRIDGE
CREATE TABLE PersonEvent (
    PersonNumber INT NOT NULL,
    EventNumber INT NOT NULL,
    PersonRoleCode VARCHAR(20) NOT NULL,
    InjuryFlag BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_person_event PRIMARY KEY (PersonNumber, EventNumber),
    CONSTRAINT fk_personevent_person
        FOREIGN KEY (PersonNumber)
        REFERENCES Person(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_personevent_event
        FOREIGN KEY (EventNumber)
        REFERENCES Event(EventNumber)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_person_event_role
        CHECK (PersonRoleCode IN ('DRIVER', 'PASSENGER', 'PEDESTRIAN', 'OWNER', 'WITNESS'))
) ENGINE = InnoDB;

-- 15. EXAM
CREATE TABLE Exam (
    ExamID INT AUTO_INCREMENT,
    PersonNumber INT NOT NULL,
    ExamDateTime DATETIME NOT NULL,
    CenterName VARCHAR(100) NOT NULL,
    AdminOfficerNumber INT NOT NULL,
    OverallScore DECIMAL(5,2),
    PassedFlag BOOLEAN,
    CONSTRAINT pk_exam PRIMARY KEY (ExamID),
    CONSTRAINT uq_exam_attempt UNIQUE (PersonNumber, ExamDateTime),
    CONSTRAINT fk_exam_operator
        FOREIGN KEY (PersonNumber)
        REFERENCES Operator(PersonNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_exam_officer
        FOREIGN KEY (AdminOfficerNumber)
        REFERENCES Officer(OfficerNumber)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_exam_score
        CHECK (OverallScore IS NULL OR OverallScore BETWEEN 0 AND 100)
) ENGINE = InnoDB;

-- 16. EXAM PART: dependent child of Exam
CREATE TABLE ExamPart (
    ExamID INT NOT NULL,
    PartCode VARCHAR(30) NOT NULL,
    PartScore DECIMAL(5,2) NOT NULL,
    MaxScore DECIMAL(5,2) NOT NULL DEFAULT 100.00,
    CONSTRAINT pk_exam_part PRIMARY KEY (ExamID, PartCode),
    CONSTRAINT fk_exampart_exam
        FOREIGN KEY (ExamID)
        REFERENCES Exam(ExamID)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT chk_exam_part_scores
        CHECK (PartScore >= 0 AND MaxScore > 0 AND PartScore <= MaxScore)
) ENGINE = InnoDB;

-- Helpful indexes for joins, temporal reports, and event reporting
CREATE INDEX idx_vehicleowner_person
    ON VehicleOwner(PersonNumber);
CREATE INDEX idx_vehicleowner_dates
    ON VehicleOwner(StartDate, EndDate);
CREATE INDEX idx_event_datetime
    ON Event(EventDateTime);
CREATE INDEX idx_event_officer
    ON Event(ReportOfficerNumber);
CREATE INDEX idx_event_cause
    ON Event(CauseEventNumber);
CREATE INDEX idx_citation_person
    ON Citation(CitedPersonNumber);
CREATE INDEX idx_exam_person_date
    ON Exam(PersonNumber, ExamDateTime);

-- Custom reporting view required by the project
CREATE VIEW CurrentVehicleOwnership AS
SELECT
    p.PersonNumber,
    p.FullName,
    v.VehicleID,
    v.VIN,
    v.YearNumber,
    v.MakeCode,
    v.ModelName,
    v.PlateID,
    v.StateCode,
    vo.StartDate,
    vo.OwnershipPercent
FROM Person AS p
JOIN VehicleOwner AS vo
    ON vo.PersonNumber = p.PersonNumber
JOIN Vehicle AS v
    ON v.VehicleID = vo.VehicleID
WHERE vo.EndDate IS NULL;

-- Bonus validation triggers: enforce Event subtype codes
DELIMITER $$

CREATE TRIGGER trg_accident_event_code_before_insert
BEFORE INSERT ON Accident
FOR EACH ROW
BEGIN
    IF (SELECT EventCode FROM Event WHERE EventNumber = NEW.EventNumber) <> 'A' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Accident must reference an Event with EventCode A';
    END IF;
END$$

CREATE TRIGGER trg_citation_event_code_before_insert
BEFORE INSERT ON Citation
FOR EACH ROW
BEGIN
    IF (SELECT EventCode FROM Event WHERE EventNumber = NEW.EventNumber) <> 'C' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Citation must reference an Event with EventCode C';
    END IF;
END$$

CREATE TRIGGER trg_event_cause_must_be_citation_before_insert
BEFORE INSERT ON Event
FOR EACH ROW
BEGIN
    IF NEW.CauseEventNumber IS NOT NULL
       AND (SELECT EventCode FROM Event WHERE EventNumber = NEW.CauseEventNumber) <> 'C' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CauseEventNumber must reference a citation event';
    END IF;
END$$

CREATE TRIGGER trg_event_cause_must_be_citation_before_update
BEFORE UPDATE ON Event
FOR EACH ROW
BEGIN
    IF NEW.CauseEventNumber IS NOT NULL
       AND (SELECT EventCode FROM Event WHERE EventNumber = NEW.CauseEventNumber) <> 'C' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'CauseEventNumber must reference a citation event';
    END IF;
END$$

DELIMITER ;

-- Verification commands
SHOW TABLES;
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dmv_project'
ORDER BY TABLE_NAME;

USE dmv_project;

SHOW TABLES;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dmv_project'
  AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;