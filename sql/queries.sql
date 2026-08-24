-- queries.sql
-- DMV Database Design and Transaction Management Project
-- Target platform: MySQL Workbench / MySQL Server
-- Q1-Q15 analytical query pack

USE dmv_project;

-- =========================================================
-- Q1. Join-heavy report:
-- List current vehicle owners with their operator and license details.
-- Demonstrates Person, Operator, License, VehicleOwner, and Vehicle joins.
-- =========================================================
SELECT
    p.PersonNumber,
    p.FullName,
    l.LicenseID,
    l.LicenseStatusCode,
    l.ExpirationDate,
    v.VehicleID,
    v.YearNumber,
    v.MakeCode,
    v.ModelName,
    v.PlateID,
    vo.StartDate AS OwnershipStartDate
FROM Person AS p
JOIN Operator AS op
    ON op.PersonNumber = p.PersonNumber
LEFT JOIN License AS l
    ON l.LicenseID = op.OperatorLicenseID
   AND l.StateCode = op.OperatorLicenseState
JOIN VehicleOwner AS vo
    ON vo.PersonNumber = p.PersonNumber
JOIN Vehicle AS v
    ON v.VehicleID = vo.VehicleID
WHERE vo.EndDate IS NULL
ORDER BY p.FullName, v.VehicleID;


-- =========================================================
-- Q2. Join-heavy report:
-- Show complete vehicle ownership history, including former owners.
-- =========================================================
SELECT
    v.VehicleID,
    v.VIN,
    CONCAT(v.YearNumber, ' ', v.MakeCode, ' ', v.ModelName) AS VehicleDescription,
    v.PlateID,
    p.PersonNumber,
    p.FullName AS OwnerName,
    vo.StartDate,
    vo.EndDate,
    CASE
        WHEN vo.EndDate IS NULL THEN 'CURRENT'
        ELSE 'FORMER'
    END AS OwnershipStatus,
    vo.OwnershipPercent
FROM Vehicle AS v
JOIN VehicleOwner AS vo
    ON vo.VehicleID = v.VehicleID
JOIN Person AS p
    ON p.PersonNumber = vo.PersonNumber
ORDER BY v.VehicleID, vo.StartDate;


-- =========================================================
-- Q3. Join-heavy report:
-- Show each citation with the cited person, reporting officer,
-- traffic code, fine, and citation status.
-- =========================================================
SELECT
    e.EventNumber,
    e.EventDateTime,
    e.LocationDesc,
    p.FullName AS CitedPerson,
    o.FullName AS ReportingOfficer,
    o.BadgeNumber,
    tc.SectionCode,
    tc.CodeDesc,
    tc.PointNumber,
    c.FineAmount,
    c.DueDate,
    c.CitationStatusCode
FROM Citation AS c
JOIN Event AS e
    ON e.EventNumber = c.EventNumber
JOIN Person AS p
    ON p.PersonNumber = c.CitedPersonNumber
JOIN Officer AS o
    ON o.OfficerNumber = e.ReportOfficerNumber
JOIN CitationTrafficCode AS ctc
    ON ctc.EventNumber = c.EventNumber
JOIN TrafficCode AS tc
    ON tc.TrafficCodeID = ctc.TrafficCodeID
ORDER BY e.EventDateTime, e.EventNumber, tc.SectionCode;


-- =========================================================
-- Q4. Join-heavy subtype report:
-- Show accidents, involved vehicles, drivers, injuries, and damage.
-- =========================================================
SELECT
    e.EventNumber,
    e.EventDateTime,
    e.LocationDesc,
    a.SeverityCode,
    a.InjuryCount,
    a.EstimatedDamageAmount,
    v.VehicleID,
    CONCAT(v.YearNumber, ' ', v.MakeCode, ' ', v.ModelName) AS VehicleDescription,
    ve.VehicleRoleCode,
    pe.PersonRoleCode,
    p.FullName AS PersonInvolved,
    pe.InjuryFlag
FROM Event AS e
JOIN Accident AS a
    ON a.EventNumber = e.EventNumber
LEFT JOIN VehicleEvent AS ve
    ON ve.EventNumber = e.EventNumber
LEFT JOIN Vehicle AS v
    ON v.VehicleID = ve.VehicleID
LEFT JOIN PersonEvent AS pe
    ON pe.EventNumber = e.EventNumber
LEFT JOIN Person AS p
    ON p.PersonNumber = pe.PersonNumber
ORDER BY e.EventNumber, v.VehicleID, p.FullName;


-- =========================================================
-- Q5. Join-heavy report:
-- Show exam attempts with operator, officer, and exam-part results.
-- =========================================================
SELECT
    ex.ExamID,
    p.FullName AS OperatorName,
    ex.ExamDateTime,
    ex.CenterName,
    o.FullName AS AdministeringOfficer,
    ex.OverallScore,
    CASE WHEN ex.PassedFlag = 1 THEN 'PASSED' ELSE 'FAILED' END AS ExamResult,
    ep.PartCode,
    ep.PartScore,
    ep.MaxScore,
    ROUND((ep.PartScore / ep.MaxScore) * 100, 2) AS PartPercent
FROM Exam AS ex
JOIN Person AS p
    ON p.PersonNumber = ex.PersonNumber
JOIN Officer AS o
    ON o.OfficerNumber = ex.AdminOfficerNumber
JOIN ExamPart AS ep
    ON ep.ExamID = ex.ExamID
ORDER BY ex.ExamID, ep.PartCode;


-- =========================================================
-- Q6. Aggregate query:
-- Count citations and total fines reported by each officer.
-- =========================================================
SELECT
    o.OfficerNumber,
    o.FullName AS OfficerName,
    o.BadgeNumber,
    COUNT(c.EventNumber) AS CitationCount,
    COALESCE(SUM(c.FineAmount), 0) AS TotalFinesIssued,
    ROUND(COALESCE(AVG(c.FineAmount), 0), 2) AS AverageFine
FROM Officer AS o
LEFT JOIN Event AS e
    ON e.ReportOfficerNumber = o.OfficerNumber
   AND e.EventCode = 'C'
LEFT JOIN Citation AS c
    ON c.EventNumber = e.EventNumber
GROUP BY
    o.OfficerNumber,
    o.FullName,
    o.BadgeNumber
ORDER BY CitationCount DESC, TotalFinesIssued DESC;


-- =========================================================
-- Q7. Aggregate query:
-- Summarize accidents by month.
-- =========================================================
SELECT
    DATE_FORMAT(e.EventDateTime, '%Y-%m') AS AccidentMonth,
    COUNT(*) AS AccidentCount,
    SUM(a.InjuryCount) AS TotalInjuries,
    SUM(a.FatalityCount) AS TotalFatalities,
    SUM(a.EstimatedDamageAmount) AS TotalEstimatedDamage,
    ROUND(AVG(a.EstimatedDamageAmount), 2) AS AverageEstimatedDamage
FROM Event AS e
JOIN Accident AS a
    ON a.EventNumber = e.EventNumber
GROUP BY DATE_FORMAT(e.EventDateTime, '%Y-%m')
ORDER BY AccidentMonth;


-- =========================================================
-- Q8. Temporal query:
-- Find vehicles that were owned at any time during calendar year 2022.
-- The overlap rule is StartDate <= range end and
-- EndDate is null or EndDate >= range start.
-- =========================================================
SELECT
    v.VehicleID,
    CONCAT(v.YearNumber, ' ', v.MakeCode, ' ', v.ModelName) AS VehicleDescription,
    v.PlateID,
    p.FullName AS OwnerName,
    vo.StartDate,
    vo.EndDate
FROM VehicleOwner AS vo
JOIN Vehicle AS v
    ON v.VehicleID = vo.VehicleID
JOIN Person AS p
    ON p.PersonNumber = vo.PersonNumber
WHERE vo.StartDate <= '2022-12-31'
  AND (vo.EndDate IS NULL OR vo.EndDate >= '2022-01-01')
ORDER BY v.VehicleID, vo.StartDate;


-- =========================================================
-- Q9. Temporal query:
-- Find licenses that expire between January 1, 2026 and
-- December 31, 2031.
-- =========================================================
SELECT
    p.PersonNumber,
    p.FullName,
    l.LicenseID,
    l.LicenseStatusCode,
    l.IssueDate,
    l.ExpirationDate,
    DATEDIFF(l.ExpirationDate, '2026-01-01') AS DaysFromPeriodStart
FROM License AS l
JOIN Operator AS op
    ON op.OperatorLicenseID = l.LicenseID
   AND op.OperatorLicenseState = l.StateCode
JOIN Person AS p
    ON p.PersonNumber = op.PersonNumber
WHERE l.ExpirationDate BETWEEN '2026-01-01' AND '2031-12-31'
ORDER BY l.ExpirationDate, p.FullName;


-- =========================================================
-- Q10. Window-function query:
-- Rank operators by their number of citations and total fines.
-- =========================================================
WITH DriverCitationTotals AS (
    SELECT
        p.PersonNumber,
        p.FullName,
        COUNT(c.EventNumber) AS CitationCount,
        COALESCE(SUM(c.FineAmount), 0) AS TotalFineAmount
    FROM Person AS p
    JOIN Operator AS op
        ON op.PersonNumber = p.PersonNumber
    LEFT JOIN Citation AS c
        ON c.CitedPersonNumber = p.PersonNumber
    GROUP BY p.PersonNumber, p.FullName
)
SELECT
    PersonNumber,
    FullName,
    CitationCount,
    TotalFineAmount,
    DENSE_RANK() OVER (
        ORDER BY CitationCount DESC, TotalFineAmount DESC
    ) AS CitationRank
FROM DriverCitationTotals
ORDER BY CitationRank, FullName;


-- =========================================================
-- Q11. Recursive query:
-- Trace each accident backward through CauseEventNumber.
-- In the sample data, caused accidents point to citation events.
-- =========================================================
WITH RECURSIVE EventCauseChain AS (
    SELECT
        e.EventNumber AS StartingAccidentNumber,
        e.EventNumber AS CurrentEventNumber,
        e.CauseEventNumber,
        e.EventCode,
        e.EventDateTime,
        e.LocationDesc,
        0 AS ChainDepth
    FROM Event AS e
    WHERE e.EventCode = 'A'
      AND e.CauseEventNumber IS NOT NULL

    UNION ALL

    SELECT
        ecc.StartingAccidentNumber,
        parent.EventNumber AS CurrentEventNumber,
        parent.CauseEventNumber,
        parent.EventCode,
        parent.EventDateTime,
        parent.LocationDesc,
        ecc.ChainDepth + 1
    FROM EventCauseChain AS ecc
    JOIN Event AS parent
        ON parent.EventNumber = ecc.CauseEventNumber
    WHERE ecc.ChainDepth < 10
)
SELECT
    StartingAccidentNumber,
    CurrentEventNumber,
    CASE EventCode
        WHEN 'A' THEN 'ACCIDENT'
        WHEN 'C' THEN 'CITATION'
    END AS EventType,
    EventDateTime,
    LocationDesc,
    CauseEventNumber,
    ChainDepth
FROM EventCauseChain
ORDER BY StartingAccidentNumber, ChainDepth;


-- =========================================================
-- Q12. Integrity query:
-- Identify vehicles that do not have a current owner.
-- A zero-row result confirms every vehicle currently has an owner.
-- =========================================================
SELECT
    v.VehicleID,
    v.VIN,
    v.PlateID,
    CONCAT(v.YearNumber, ' ', v.MakeCode, ' ', v.ModelName) AS VehicleDescription
FROM Vehicle AS v
LEFT JOIN VehicleOwner AS vo
    ON vo.VehicleID = v.VehicleID
   AND vo.EndDate IS NULL
WHERE vo.VehicleID IS NULL
ORDER BY v.VehicleID;


-- =========================================================
-- Q13. Supertype/subtype query:
-- Show all events with accident- or citation-specific fields.
-- =========================================================
SELECT
    e.EventNumber,
    e.EventDateTime,
    e.LocationDesc,
    CASE e.EventCode
        WHEN 'A' THEN 'ACCIDENT'
        WHEN 'C' THEN 'CITATION'
    END AS EventType,
    o.FullName AS ReportingOfficer,
    a.SeverityCode,
    a.InjuryCount,
    a.EstimatedDamageAmount,
    p.FullName AS CitedPerson,
    c.FineAmount,
    c.CitationStatusCode
FROM Event AS e
JOIN Officer AS o
    ON o.OfficerNumber = e.ReportOfficerNumber
LEFT JOIN Accident AS a
    ON a.EventNumber = e.EventNumber
LEFT JOIN Citation AS c
    ON c.EventNumber = e.EventNumber
LEFT JOIN Person AS p
    ON p.PersonNumber = c.CitedPersonNumber
ORDER BY e.EventDateTime, e.EventNumber;


-- =========================================================
-- Q14. View query:
-- Use the CurrentVehicleOwnership view to simplify a common report.
-- =========================================================
SELECT
    PersonNumber,
    FullName,
    VehicleID,
    VIN,
    YearNumber,
    MakeCode,
    ModelName,
    PlateID,
    StateCode,
    StartDate,
    OwnershipPercent
FROM CurrentVehicleOwnership
ORDER BY FullName, VehicleID;


-- =========================================================
-- Q15. Additional analytical query:
-- Find drivers with unpaid citations and summarize the balance due.
-- =========================================================
SELECT
    p.PersonNumber,
    p.FullName,
    COUNT(c.EventNumber) AS UnpaidCitationCount,
    SUM(c.FineAmount) AS OutstandingFineBalance,
    MIN(c.DueDate) AS EarliestDueDate,
    SUM(CASE WHEN c.CitationStatusCode = 'OVERDUE' THEN 1 ELSE 0 END) AS OverdueCitationCount
FROM Person AS p
JOIN Citation AS c
    ON c.CitedPersonNumber = p.PersonNumber
WHERE c.CitationStatusCode IN ('OPEN', 'OVERDUE')
GROUP BY p.PersonNumber, p.FullName
HAVING COUNT(c.EventNumber) > 0
ORDER BY OutstandingFineBalance DESC, p.FullName;
