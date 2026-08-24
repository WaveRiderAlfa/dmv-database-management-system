-- seed_data.sql
-- Synthetic DMV data for CYBR 216
-- Target: MySQL Workbench / database: dmv_project
-- All names, addresses, identifiers, and events are fictional.

USE dmv_project;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM ExamPart;
DELETE FROM Exam;
DELETE FROM PersonEvent;
DELETE FROM VehicleEvent;
DELETE FROM CitationTrafficCode;
DELETE FROM Citation;
DELETE FROM Accident;
DELETE FROM Event;
DELETE FROM VehicleOwner;
DELETE FROM Vehicle;
DELETE FROM Officer;
DELETE FROM Operator;
DELETE FROM License;
DELETE FROM Address;
DELETE FROM TrafficCode;
DELETE FROM Person;
SET FOREIGN_KEY_CHECKS = 1;

ALTER TABLE Person AUTO_INCREMENT = 1;
ALTER TABLE Officer AUTO_INCREMENT = 1;
ALTER TABLE Vehicle AUTO_INCREMENT = 1;
ALTER TABLE Event AUTO_INCREMENT = 1;
ALTER TABLE TrafficCode AUTO_INCREMENT = 1;
ALTER TABLE Exam AUTO_INCREMENT = 1;

INSERT INTO Person (PersonNumber, FullName, BirthDate, SexCode, PhoneNumber, EmailAddress) VALUES
(1, 'Marcus Reed', '1968-01-01', 'M', '518-555-1001', 'marcus.reed@example.com'),
(2, 'Tiana Brooks', '1971-06-08', 'F', '518-555-1002', 'tiana.brooks@example.com'),
(3, 'Jordan Carter', '1974-11-15', 'M', '518-555-1003', 'jordan.carter@example.com'),
(4, 'Aaliyah Johnson', '1977-04-22', 'F', '518-555-1004', 'aaliyah.johnson@example.com'),
(5, 'Daniel Miller', '1980-09-02', 'M', '518-555-1005', 'daniel.miller@example.com'),
(6, 'Naomi Wilson', '1983-02-09', 'F', '518-555-1006', 'naomi.wilson@example.com'),
(7, 'Isaiah Davis', '1986-07-16', 'M', '518-555-1007', 'isaiah.davis@example.com'),
(8, 'Brianna Thompson', '1989-12-23', 'F', '518-555-1008', 'brianna.thompson@example.com'),
(9, 'Malik Moore', '1992-05-03', 'X', '518-555-1009', 'malik.moore@example.com'),
(10, 'Sofia Clark', '1995-10-10', 'F', '518-555-1010', 'sofia.clark@example.com'),
(11, 'Andre Lewis', '1998-03-17', 'M', '518-555-1011', 'andre.lewis@example.com'),
(12, 'Jasmine Walker', '2001-08-24', 'F', '518-555-1012', 'jasmine.walker@example.com'),
(13, 'Caleb Hall', '1969-01-04', 'M', '518-555-1013', 'caleb.hall@example.com'),
(14, 'Maya Allen', '1972-06-11', 'F', '518-555-1014', 'maya.allen@example.com'),
(15, 'Noah Young', '1975-11-18', 'M', '518-555-1015', 'noah.young@example.com'),
(16, 'Kiara King', '1978-04-25', 'F', '518-555-1016', 'kiara.king@example.com'),
(17, 'Ethan Wright', '1981-09-05', 'M', '518-555-1017', 'ethan.wright@example.com'),
(18, 'Nia Scott', '1984-02-12', 'F', '518-555-1018', 'nia.scott@example.com'),
(19, 'Darius Green', '1987-07-19', 'X', '518-555-1019', 'darius.green@example.com'),
(20, 'Elena Baker', '1990-12-26', 'F', '518-555-1020', 'elena.baker@example.com'),
(21, 'Julian Adams', '1993-05-06', 'M', '518-555-1021', 'julian.adams@example.com'),
(22, 'Zoe Nelson', '1996-10-13', 'F', '518-555-1022', 'zoe.nelson@example.com'),
(23, 'Micah Hill', '1999-03-20', 'M', '518-555-1023', 'micah.hill@example.com'),
(24, 'Camila Campbell', '2002-08-27', 'F', '518-555-1024', 'camila.campbell@example.com'),
(25, 'Devin Mitchell', '1970-01-07', 'M', '518-555-1025', 'devin.mitchell@example.com'),
(26, 'Layla Roberts', '1973-06-14', 'F', '518-555-1026', 'layla.roberts@example.com'),
(27, 'Owen Turner', '1976-11-21', 'M', '518-555-1027', 'owen.turner@example.com'),
(28, 'Amara Phillips', '1979-04-01', 'F', '518-555-1028', 'amara.phillips@example.com'),
(29, 'Xavier Parker', '1982-09-08', 'X', '518-555-1029', 'xavier.parker@example.com'),
(30, 'Leah Evans', '1985-02-15', 'F', '518-555-1030', 'leah.evans@example.com'),
(31, 'Adrian Edwards', '1988-07-22', 'M', '518-555-1031', 'adrian.edwards@example.com'),
(32, 'Imani Collins', '1991-12-02', 'F', '518-555-1032', 'imani.collins@example.com'),
(33, 'Miles Stewart', '1994-05-09', 'M', '518-555-1033', 'miles.stewart@example.com'),
(34, 'Gabrielle Morris', '1997-10-16', 'F', '518-555-1034', 'gabrielle.morris@example.com'),
(35, 'Nathan Rogers', '2000-03-23', 'M', '518-555-1035', 'nathan.rogers@example.com'),
(36, 'Selena Cook', '1968-08-03', 'F', '518-555-1036', 'selena.cook@example.com'),
(37, 'Jeremiah Morgan', '1971-01-10', 'M', '518-555-1037', 'jeremiah.morgan@example.com'),
(38, 'Ava Bell', '1974-06-17', 'F', '518-555-1038', 'ava.bell@example.com'),
(39, 'Dominic Murphy', '1977-11-24', 'X', '518-555-1039', 'dominic.murphy@example.com'),
(40, 'Renee Bailey', '1980-04-04', 'F', '518-555-1040', 'renee.bailey@example.com');

INSERT INTO Address (PersonNumber, Street1Desc, Street2Desc, CityName, StateCode, PostalCode) VALUES
(1, '125 Hudson Ave', 'Apt 1', 'Albany', 'NY', '12200'),
(2, '44 Pine Street', NULL, 'Troy', 'NY', '12201'),
(3, '981 Madison Ave', NULL, 'Schenectady', 'NY', '12202'),
(4, '72 Western Ave', NULL, 'Colonie', 'NY', '12203'),
(5, '310 Central Ave', 'Apt 2', 'Latham', 'NY', '12204'),
(6, '18 State Street', NULL, 'Watervliet', 'NY', '12205'),
(7, '455 New Scotland Ave', NULL, 'Cohoes', 'NY', '12206'),
(8, '92 Lark Street', NULL, 'Rensselaer', 'NY', '12207'),
(9, '611 Washington Ave', 'Apt 3', 'Albany', 'NY', '12208'),
(10, '203 Quail Street', NULL, 'Troy', 'NY', '12209'),
(11, '88 Delaware Ave', NULL, 'Schenectady', 'NY', '12210'),
(12, '145 Ontario Street', NULL, 'Colonie', 'NY', '12211'),
(13, '733 Broadway', 'Apt 4', 'Latham', 'NY', '12212'),
(14, '27 Manning Blvd', NULL, 'Watervliet', 'NY', '12213'),
(15, '501 Myrtle Ave', NULL, 'Cohoes', 'NY', '12214'),
(16, '160 Clinton Ave', NULL, 'Rensselaer', 'NY', '12215'),
(17, '39 South Pearl Street', 'Apt 5', 'Albany', 'NY', '12216'),
(18, '284 Orange Street', NULL, 'Troy', 'NY', '12217'),
(19, '607 Livingston Ave', NULL, 'Schenectady', 'NY', '12218'),
(20, '11 Dove Street', NULL, 'Colonie', 'NY', '12219'),
(21, '225 Colvin Ave', 'Apt 6', 'Latham', 'NY', '12220'),
(22, '96 North Allen Street', NULL, 'Watervliet', 'NY', '12221'),
(23, '714 Morris Street', NULL, 'Cohoes', 'NY', '12222'),
(24, '51 Elk Street', NULL, 'Rensselaer', 'NY', '12223'),
(25, '340 Second Street', 'Apt 7', 'Albany', 'NY', '12224'),
(26, '122 First Street', NULL, 'Troy', 'NY', '12200'),
(27, '419 Third Street', NULL, 'Schenectady', 'NY', '12201'),
(28, '68 Academy Road', NULL, 'Colonie', 'NY', '12202'),
(29, '905 New Loudon Road', 'Apt 8', 'Latham', 'NY', '12203'),
(30, '37 River Street', NULL, 'Watervliet', 'NY', '12204'),
(31, '210 Troy Schenectady Road', NULL, 'Cohoes', 'NY', '12205'),
(32, '87 Wolf Road', NULL, 'Rensselaer', 'NY', '12206'),
(33, '601 Watervliet Shaker Road', 'Apt 9', 'Albany', 'NY', '12207'),
(34, '14 Vly Road', NULL, 'Troy', 'NY', '12208'),
(35, '320 Route 9', NULL, 'Schenectady', 'NY', '12209'),
(36, '109 Sand Creek Road', NULL, 'Colonie', 'NY', '12210'),
(37, '75 Fuller Road', 'Apt 10', 'Latham', 'NY', '12211'),
(38, '430 Albany Shaker Road', NULL, 'Watervliet', 'NY', '12212'),
(39, '28 Osborne Road', NULL, 'Cohoes', 'NY', '12213'),
(40, '800 Loudon Road', NULL, 'Rensselaer', 'NY', '12214');

INSERT INTO License (LicenseID, StateCode, IssueDate, ExpirationDate, LicenseStatusCode, NCFlag, MFlag, CFFlag, CPFlag) VALUES
('NYD00000001', 'NY', '2018-01-01', '2026-01-01', 'ACTIVE', 1, 1, 1, 1),
('NYD00000002', 'NY', '2019-02-04', '2027-02-04', 'ACTIVE', 0, 0, 0, 0),
('NYD00000003', 'NY', '2020-03-07', '2028-03-07', 'ACTIVE', 0, 0, 0, 0),
('NYD00000004', 'NY', '2021-04-10', '2029-04-10', 'ACTIVE', 0, 0, 0, 0),
('NYD00000005', 'NY', '2022-05-13', '2030-05-13', 'ACTIVE', 0, 0, 0, 0),
('NYD00000006', 'NY', '2023-06-16', '2031-06-16', 'ACTIVE', 0, 0, 0, 0),
('NYD00000007', 'NY', '2018-07-19', '2026-07-19', 'ACTIVE', 0, 0, 0, 0),
('NYD00000008', 'NY', '2019-08-22', '2027-08-22', 'ACTIVE', 0, 1, 0, 0),
('NYD00000009', 'NY', '2020-09-25', '2028-09-25', 'ACTIVE', 0, 0, 0, 0),
('NYD00000010', 'NY', '2021-10-01', '2029-10-01', 'ACTIVE', 1, 0, 0, 0),
('NYD00000011', 'NY', '2022-11-04', '2030-11-04', 'ACTIVE', 0, 0, 0, 0),
('NYD00000012', 'NY', '2023-12-07', '2031-12-07', 'ACTIVE', 0, 0, 1, 0),
('NYD00000013', 'NY', '2018-01-10', '2026-01-10', 'ACTIVE', 0, 0, 0, 0),
('NYD00000014', 'NY', '2019-02-13', '2027-02-13', 'ACTIVE', 0, 0, 0, 1),
('NYD00000015', 'NY', '2020-03-16', '2028-03-16', 'ACTIVE', 0, 1, 0, 0),
('NYD00000016', 'NY', '2021-04-19', '2029-04-19', 'ACTIVE', 0, 0, 0, 0),
('NYD00000017', 'NY', '2022-05-22', '2030-05-22', 'ACTIVE', 0, 0, 0, 0),
('NYD00000018', 'NY', '2023-06-25', '2031-06-25', 'ACTIVE', 0, 0, 0, 0),
('NYD00000019', 'NY', '2018-07-01', '2026-07-01', 'ACTIVE', 1, 0, 0, 0),
('NYD00000020', 'NY', '2019-08-04', '2027-08-04', 'ACTIVE', 0, 0, 0, 0),
('NYD00000021', 'NY', '2020-09-07', '2028-09-07', 'ACTIVE', 0, 0, 0, 0),
('NYD00000022', 'NY', '2021-10-10', '2029-10-10', 'ACTIVE', 0, 1, 0, 0),
('NYD00000023', 'NY', '2022-11-13', '2030-11-13', 'ACTIVE', 0, 0, 1, 0),
('NYD00000024', 'NY', '2023-12-16', '2031-12-16', 'ACTIVE', 0, 0, 0, 0),
('NYD00000025', 'NY', '2018-01-19', '2026-01-19', 'EXPIRED', 0, 0, 0, 0),
('NYD00000026', 'NY', '2019-02-22', '2027-02-22', 'EXPIRED', 0, 0, 0, 0),
('NYD00000027', 'NY', '2020-03-25', '2028-03-25', 'EXPIRED', 0, 0, 0, 1),
('NYD00000028', 'NY', '2021-04-01', '2029-04-01', 'EXPIRED', 1, 0, 0, 0),
('NYD00000029', 'NY', '2022-05-04', '2030-05-04', 'SUSPENDED', 0, 1, 0, 0),
('NYD00000030', 'NY', '2023-06-07', '2031-06-07', 'SUSPENDED', 0, 0, 0, 0),
('NYD00000031', 'NY', '2018-07-10', '2026-07-10', 'SUSPENDED', 0, 0, 0, 0),
('NYD00000032', 'NY', '2019-08-13', '2027-08-13', 'REVOKED', 0, 0, 0, 0);

INSERT INTO Operator (PersonNumber, EyeGlassFlag, HairColorCode, EyeColorCode, OperatorLicenseID, OperatorLicenseState) VALUES
(1, 1, 'BLACK', 'BROWN', 'NYD00000001', 'NY'),
(2, 0, 'BROWN', 'BLUE', 'NYD00000002', 'NY'),
(3, 0, 'BLONDE', 'GREEN', 'NYD00000003', 'NY'),
(4, 1, 'RED', 'HAZEL', 'NYD00000004', 'NY'),
(5, 0, 'GRAY', 'GRAY', 'NYD00000005', 'NY'),
(6, 0, 'BLACK', 'BROWN', 'NYD00000006', 'NY'),
(7, 1, 'BROWN', 'BLUE', 'NYD00000007', 'NY'),
(8, 0, 'BLONDE', 'GREEN', 'NYD00000008', 'NY'),
(9, 0, 'RED', 'HAZEL', 'NYD00000009', 'NY'),
(10, 1, 'GRAY', 'GRAY', 'NYD00000010', 'NY'),
(11, 0, 'BLACK', 'BROWN', 'NYD00000011', 'NY'),
(12, 0, 'BROWN', 'BLUE', 'NYD00000012', 'NY'),
(13, 1, 'BLONDE', 'GREEN', 'NYD00000013', 'NY'),
(14, 0, 'RED', 'HAZEL', 'NYD00000014', 'NY'),
(15, 0, 'GRAY', 'GRAY', 'NYD00000015', 'NY'),
(16, 1, 'BLACK', 'BROWN', 'NYD00000016', 'NY'),
(17, 0, 'BROWN', 'BLUE', 'NYD00000017', 'NY'),
(18, 0, 'BLONDE', 'GREEN', 'NYD00000018', 'NY'),
(19, 1, 'RED', 'HAZEL', 'NYD00000019', 'NY'),
(20, 0, 'GRAY', 'GRAY', 'NYD00000020', 'NY'),
(21, 0, 'BLACK', 'BROWN', 'NYD00000021', 'NY'),
(22, 1, 'BROWN', 'BLUE', 'NYD00000022', 'NY'),
(23, 0, 'BLONDE', 'GREEN', 'NYD00000023', 'NY'),
(24, 0, 'RED', 'HAZEL', 'NYD00000024', 'NY'),
(25, 1, 'GRAY', 'GRAY', 'NYD00000025', 'NY'),
(26, 0, 'BLACK', 'BROWN', 'NYD00000026', 'NY'),
(27, 0, 'BROWN', 'BLUE', 'NYD00000027', 'NY'),
(28, 1, 'BLONDE', 'GREEN', 'NYD00000028', 'NY'),
(29, 0, 'RED', 'HAZEL', 'NYD00000029', 'NY'),
(30, 0, 'GRAY', 'GRAY', 'NYD00000030', 'NY'),
(31, 1, 'BLACK', 'BROWN', 'NYD00000031', 'NY'),
(32, 0, 'BROWN', 'BLUE', 'NYD00000032', 'NY');

INSERT INTO Officer (OfficerNumber, BadgeNumber, DepartmentCode, FullName, RankCode, ActiveFlag) VALUES
(1, 'B4100', 'ALBANY_PD', 'Olivia Grant', 'OFFICER', 1),
(2, 'B4101', 'TROY_PD', 'Henry Walsh', 'SERGEANT', 1),
(3, 'B4102', 'SCHENECTADY_PD', 'Priya Shah', 'OFFICER', 1),
(4, 'B4103', 'NYSP', 'Michael Torres', 'LIEUTENANT', 1),
(5, 'B4104', 'COLONIE_PD', 'Dana Kim', 'OFFICER', 1),
(6, 'B4105', 'ALBANY_PD', 'Robert Fields', 'SERGEANT', 1),
(7, 'B4106', 'NYSP', 'Linda Chen', 'OFFICER', 1),
(8, 'B4107', 'RENSSELAER_PD', 'Samuel Price', 'OFFICER', 1);

INSERT INTO Vehicle (VehicleID, TypeCode, YearNumber, MakeCode, ModelName, VIN, PlateID, StateCode, RegistrationDate, RegistrationExpirationDate) VALUES
(1, 'SEDAN', 2012, 'Toyota', 'Camry', '1DMV2160000000001', 'DMV0001', 'NY', '2025-01-01', '2027-01-01'),
(2, 'SEDAN', 2013, 'Honda', 'Civic', '1DMV2160000000002', 'DMV0002', 'NY', '2025-02-03', '2027-02-03'),
(3, 'SUV', 2014, 'Ford', 'Escape', '1DMV2160000000003', 'DMV0003', 'NY', '2025-03-05', '2027-03-05'),
(4, 'SEDAN', 2015, 'Chevrolet', 'Malibu', '1DMV2160000000004', 'DMV0004', 'NY', '2025-04-07', '2027-04-07'),
(5, 'SEDAN', 2016, 'Nissan', 'Altima', '1DMV2160000000005', 'DMV0005', 'NY', '2025-05-09', '2027-05-09'),
(6, 'SEDAN', 2017, 'Hyundai', 'Elantra', '1DMV2160000000006', 'DMV0006', 'NY', '2025-06-11', '2027-06-11'),
(7, 'WAGON', 2018, 'Subaru', 'Outback', '1DMV2160000000007', 'DMV0007', 'NY', '2025-07-13', '2027-07-13'),
(8, 'SUV', 2019, 'Jeep', 'Cherokee', '1DMV2160000000008', 'DMV0008', 'NY', '2025-08-15', '2027-08-15'),
(9, 'SUV', 2020, 'Kia', 'Sportage', '1DMV2160000000009', 'DMV0009', 'NY', '2025-09-17', '2027-09-17'),
(10, 'SUV', 2021, 'Mazda', 'CX-5', '1DMV2160000000010', 'DMV0010', 'NY', '2025-10-19', '2027-10-19'),
(11, 'SEDAN', 2022, 'Volkswagen', 'Jetta', '1DMV2160000000011', 'DMV0011', 'NY', '2025-11-21', '2027-11-21'),
(12, 'SEDAN', 2023, 'BMW', '3 Series', '1DMV2160000000012', 'DMV0012', 'NY', '2025-12-23', '2027-12-23'),
(13, 'SEDAN', 2024, 'Mercedes-Benz', 'C-Class', '1DMV2160000000013', 'DMV0013', 'NY', '2025-01-25', '2027-01-25'),
(14, 'SEDAN', 2025, 'Tesla', 'Model 3', '1DMV2160000000014', 'DMV0014', 'NY', '2025-02-27', '2027-02-27'),
(15, 'SUV', 2012, 'Lexus', 'RX', '1DMV2160000000015', 'DMV0015', 'NY', '2025-03-02', '2027-03-02'),
(16, 'SEDAN', 2013, 'Acura', 'TLX', '1DMV2160000000016', 'DMV0016', 'NY', '2025-04-04', '2027-04-04'),
(17, 'SUV', 2014, 'Buick', 'Encore', '1DMV2160000000017', 'DMV0017', 'NY', '2025-05-06', '2027-05-06'),
(18, 'SUV', 2015, 'GMC', 'Terrain', '1DMV2160000000018', 'DMV0018', 'NY', '2025-06-08', '2027-06-08'),
(19, 'TRUCK', 2016, 'Ram', '1500', '1DMV2160000000019', 'DMV0019', 'NY', '2025-07-10', '2027-07-10'),
(20, 'TRUCK', 2017, 'Ford', 'F-150', '1DMV2160000000020', 'DMV0020', 'NY', '2025-08-12', '2027-08-12'),
(21, 'SUV', 2018, 'Toyota', 'RAV4', '1DMV2160000000021', 'DMV0021', 'NY', '2025-09-14', '2027-09-14'),
(22, 'SEDAN', 2019, 'Honda', 'Accord', '1DMV2160000000022', 'DMV0022', 'NY', '2025-10-16', '2027-10-16'),
(23, 'SUV', 2020, 'Nissan', 'Rogue', '1DMV2160000000023', 'DMV0023', 'NY', '2025-11-18', '2027-11-18'),
(24, 'SUV', 2021, 'Chevrolet', 'Equinox', '1DMV2160000000024', 'DMV0024', 'NY', '2025-12-20', '2027-12-20'),
(25, 'SUV', 2022, 'Hyundai', 'Tucson', '1DMV2160000000025', 'DMV0025', 'NY', '2025-01-22', '2027-01-22'),
(26, 'SUV', 2023, 'Subaru', 'Forester', '1DMV2160000000026', 'DMV0026', 'NY', '2025-02-24', '2027-02-24'),
(27, 'HATCHBACK', 2024, 'Kia', 'Soul', '1DMV2160000000027', 'DMV0027', 'NY', '2025-03-26', '2027-03-26'),
(28, 'SEDAN', 2025, 'Mazda', 'Mazda3', '1DMV2160000000028', 'DMV0028', 'NY', '2025-04-01', '2027-04-01'),
(29, 'SUV', 2012, 'Volvo', 'XC60', '1DMV2160000000029', 'DMV0029', 'NY', '2025-05-03', '2027-05-03'),
(30, 'SEDAN', 2013, 'Audi', 'A4', '1DMV2160000000030', 'DMV0030', 'NY', '2025-06-05', '2027-06-05');

INSERT INTO VehicleOwner (VehicleID, PersonNumber, StartDate, EndDate, OwnershipPercent) VALUES
(1, 1, '2020-01-01', NULL, 100.00),
(2, 2, '2021-02-04', NULL, 100.00),
(3, 3, '2022-03-07', NULL, 100.00),
(4, 4, '2023-04-10', NULL, 100.00),
(5, 5, '2024-05-13', NULL, 100.00),
(6, 6, '2025-06-16', NULL, 100.00),
(7, 7, '2020-07-19', NULL, 100.00),
(8, 8, '2021-08-22', NULL, 100.00),
(9, 9, '2022-09-25', NULL, 100.00),
(10, 10, '2023-10-01', NULL, 100.00),
(11, 11, '2024-11-04', NULL, 100.00),
(12, 12, '2025-12-07', NULL, 100.00),
(13, 13, '2020-01-10', NULL, 100.00),
(14, 14, '2021-02-13', NULL, 100.00),
(15, 15, '2022-03-16', NULL, 100.00),
(16, 16, '2023-04-19', NULL, 100.00),
(17, 17, '2024-05-22', NULL, 100.00),
(18, 18, '2025-06-25', NULL, 100.00),
(19, 19, '2020-07-01', NULL, 100.00),
(20, 20, '2021-08-04', NULL, 100.00),
(21, 21, '2022-09-07', NULL, 100.00),
(22, 22, '2023-10-10', NULL, 100.00),
(23, 23, '2024-11-13', NULL, 100.00),
(24, 24, '2025-12-16', NULL, 100.00),
(25, 25, '2020-01-19', NULL, 100.00),
(26, 26, '2021-02-22', NULL, 100.00),
(27, 27, '2022-03-25', NULL, 100.00),
(28, 28, '2023-04-01', NULL, 100.00),
(29, 29, '2024-05-04', NULL, 100.00),
(30, 30, '2025-06-07', NULL, 100.00),
(1, 33, '2016-03-10', '2019-06-15', 100.00),
(2, 34, '2017-04-11', '2020-07-16', 100.00),
(3, 35, '2018-05-12', '2021-08-17', 100.00),
(4, 36, '2016-06-13', '2019-09-18', 100.00),
(5, 37, '2017-07-14', '2020-10-19', 100.00),
(6, 38, '2018-08-15', '2021-11-20', 100.00);

INSERT INTO TrafficCode (TrafficCodeID, SectionCode, CodeDesc, DefaultFineAmount, PointNumber) VALUES
(1, 'VTL-1180D', 'Speeding over posted limit', 150.00, 4),
(2, 'VTL-1110A', 'Failure to obey traffic control device', 175.00, 2),
(3, 'VTL-1225C', 'Use of portable electronic device while driving', 200.00, 5),
(4, 'VTL-1128A', 'Unsafe lane change', 150.00, 3),
(5, 'VTL-1172A', 'Failure to stop at stop sign', 175.00, 3),
(6, 'VTL-1192', 'Driving while intoxicated', 1000.00, 8),
(7, 'VTL-375', 'Equipment violation', 75.00, 0),
(8, 'VTL-509', 'Unlicensed operation', 300.00, 0),
(9, 'VTL-319', 'Operating without insurance', 450.00, 0),
(10, 'VTL-1163', 'Failure to signal', 100.00, 2),
(11, 'VTL-1212', 'Reckless driving', 500.00, 5),
(12, 'VTL-1144A', 'Failure to yield to emergency vehicle', 275.00, 3);

INSERT INTO Event (EventNumber, EventDateTime, LocationDesc, ReportDesc, EventCode, CauseEventNumber, ReportOfficerNumber) VALUES
(1, '2026-01-03 08:15:00', 'Central Ave at Colvin Ave, Albany', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 1),
(2, '2026-02-04 09:15:00', 'I-787 North near Exit 4', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 2),
(3, '2026-03-05 10:15:00', 'Western Ave at Fuller Road', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 3),
(4, '2026-04-06 11:15:00', 'Route 7 near Troy-Schenectady Road', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 4),
(5, '2026-05-07 12:15:00', 'Madison Ave at Lark Street', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 5),
(6, '2026-06-08 13:15:00', 'I-90 East near Exit 6', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 6),
(7, '2026-01-09 14:15:00', 'Wolf Road at Sand Creek Road', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 7),
(8, '2026-02-10 15:15:00', 'Broadway at State Street, Albany', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 8),
(9, '2026-03-11 16:15:00', 'Route 9 near Latham Circle', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 1),
(10, '2026-04-12 17:15:00', 'Washington Ave at Quail Street', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 2),
(11, '2026-05-13 08:15:00', 'Hoosick Street at 15th Street, Troy', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 3),
(12, '2026-06-14 09:15:00', 'Erie Blvd near State Street', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 4),
(13, '2026-01-15 10:15:00', 'Delaware Ave at Whitehall Road', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 5),
(14, '2026-02-16 11:15:00', 'New Scotland Ave near Academy Road', 'Traffic stop and citation issued after officer observation.', 'C', NULL, 6);

INSERT INTO Event (EventNumber, EventDateTime, LocationDesc, ReportDesc, EventCode, CauseEventNumber, ReportOfficerNumber) VALUES
(15, '2026-02-05 10:30:00', 'Central Ave at Manning Blvd', 'Motor vehicle collision documented at the scene.', 'A', 1, 1),
(16, '2026-03-06 11:30:00', 'I-787 South near Exit 2', 'Motor vehicle collision documented at the scene.', 'A', NULL, 2),
(17, '2026-04-07 12:30:00', 'Western Ave at Brevator Street', 'Motor vehicle collision documented at the scene.', 'A', 3, 3),
(18, '2026-05-08 13:30:00', 'Route 9W near Southern Blvd', 'Motor vehicle collision documented at the scene.', 'A', 4, 4),
(19, '2026-06-09 14:30:00', 'Washington Ave Extension near Crossgates Mall', 'Motor vehicle collision documented at the scene.', 'A', NULL, 5),
(20, '2026-02-10 15:30:00', 'Troy Road at Mannix Road', 'Motor vehicle collision documented at the scene.', 'A', 6, 6),
(21, '2026-03-11 16:30:00', 'Madison Ave at South Lake Ave', 'Motor vehicle collision documented at the scene.', 'A', 7, 7),
(22, '2026-04-12 17:30:00', 'I-90 West near Exit 5', 'Motor vehicle collision documented at the scene.', 'A', NULL, 8),
(23, '2026-05-13 10:30:00', 'Hoosick Street near Burdett Ave', 'Motor vehicle collision documented at the scene.', 'A', 9, 1),
(24, '2026-06-14 11:30:00', 'State Street at Broadway, Schenectady', 'Motor vehicle collision documented at the scene.', 'A', 10, 2);

INSERT INTO Accident (EventNumber, SeverityCode, InjuryCount, FatalityCount, EstimatedDamageAmount, WeatherCode, RoadConditionCode) VALUES
(15, 'MINOR', 0, 0, 1800.00, 'CLEAR', 'DRY'),
(16, 'MODERATE', 1, 0, 6200.00, 'RAIN', 'WET'),
(17, 'MINOR', 0, 0, 2500.00, 'CLEAR', 'DRY'),
(18, 'SEVERE', 2, 0, 18500.00, 'SNOW', 'ICY'),
(19, 'MODERATE', 1, 0, 7600.00, 'CLOUDY', 'DRY'),
(20, 'MINOR', 0, 0, 3200.00, 'CLEAR', 'DRY'),
(21, 'MODERATE', 1, 0, 9800.00, 'RAIN', 'WET'),
(22, 'SEVERE', 3, 0, 24000.00, 'FOG', 'WET'),
(23, 'MINOR', 0, 0, 1500.00, 'CLEAR', 'DRY'),
(24, 'MODERATE', 1, 0, 6800.00, 'CLOUDY', 'DRY');

INSERT INTO Citation (EventNumber, CitedPersonNumber, FineAmount, DueDate, CitationStatusCode, CourtName) VALUES
(1, 1, 150.00, '2026-03-15', 'PAID', 'Albany County Traffic Court'),
(2, 2, 175.00, '2026-04-16', 'OPEN', 'Albany County Traffic Court'),
(3, 3, 200.00, '2026-05-17', 'PAID', 'Albany County Traffic Court'),
(4, 4, 150.00, '2026-06-18', 'DISMISSED', 'Albany County Traffic Court'),
(5, 5, 175.00, '2026-07-19', 'OPEN', 'Albany County Traffic Court'),
(6, 6, 1000.00, '2026-03-20', 'OVERDUE', 'Albany County Traffic Court'),
(7, 7, 75.00, '2026-04-21', 'PAID', 'Albany County Traffic Court'),
(8, 8, 300.00, '2026-05-22', 'OPEN', 'Albany County Traffic Court'),
(9, 9, 450.00, '2026-06-23', 'PAID', 'Albany County Traffic Court'),
(10, 10, 100.00, '2026-07-24', 'OPEN', 'Albany County Traffic Court'),
(11, 11, 500.00, '2026-03-15', 'PAID', 'Albany County Traffic Court'),
(12, 12, 275.00, '2026-04-16', 'OVERDUE', 'Albany County Traffic Court'),
(13, 13, 200.00, '2026-05-17', 'OPEN', 'Albany County Traffic Court'),
(14, 14, 150.00, '2026-06-18', 'PAID', 'Albany County Traffic Court');

INSERT INTO CitationTrafficCode (EventNumber, TrafficCodeID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 3),
(13, 4),
(14, 1),
(14, 10),
(6, 9),
(11, 2);

INSERT INTO VehicleEvent (VehicleID, EventNumber, VehicleRoleCode, DamageDesc) VALUES
(1, 1, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(2, 2, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(3, 3, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(4, 4, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(5, 5, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(6, 6, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(7, 7, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(8, 8, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(9, 9, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(10, 10, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(11, 11, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(12, 12, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(13, 13, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(14, 14, 'INVOLVED', 'No collision damage; vehicle associated with traffic stop.'),
(1, 15, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(2, 15, 'VICTIM', 'Rear or side panel damage documented.'),
(3, 16, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(4, 16, 'VICTIM', 'Rear or side panel damage documented.'),
(5, 17, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(6, 17, 'VICTIM', 'Rear or side panel damage documented.'),
(7, 18, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(8, 18, 'VICTIM', 'Rear or side panel damage documented.'),
(9, 19, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(11, 20, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(13, 21, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(15, 22, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(17, 23, 'AT_FAULT', 'Front-end or side impact damage documented.'),
(19, 24, 'AT_FAULT', 'Front-end or side impact damage documented.');

INSERT INTO PersonEvent (PersonNumber, EventNumber, PersonRoleCode, InjuryFlag) VALUES
(1, 1, 'DRIVER', 0),
(2, 2, 'DRIVER', 0),
(3, 3, 'DRIVER', 0),
(4, 4, 'DRIVER', 0),
(5, 5, 'DRIVER', 0),
(6, 6, 'DRIVER', 0),
(7, 7, 'DRIVER', 0),
(8, 8, 'DRIVER', 0),
(9, 9, 'DRIVER', 0),
(10, 10, 'DRIVER', 0),
(11, 11, 'DRIVER', 0),
(12, 12, 'DRIVER', 0),
(13, 13, 'DRIVER', 0),
(14, 14, 'DRIVER', 0),
(1, 15, 'DRIVER', 0),
(2, 15, 'DRIVER', 0),
(3, 16, 'DRIVER', 1),
(4, 16, 'DRIVER', 0),
(5, 17, 'DRIVER', 0),
(6, 17, 'DRIVER', 0),
(7, 18, 'DRIVER', 1),
(8, 18, 'DRIVER', 1),
(31, 18, 'PASSENGER', 1),
(9, 19, 'DRIVER', 1),
(10, 19, 'DRIVER', 0),
(11, 20, 'DRIVER', 0),
(12, 20, 'DRIVER', 0),
(13, 21, 'DRIVER', 1),
(14, 21, 'DRIVER', 0),
(15, 22, 'DRIVER', 1),
(16, 22, 'DRIVER', 1),
(17, 23, 'DRIVER', 0),
(18, 23, 'DRIVER', 0),
(19, 24, 'DRIVER', 1),
(20, 24, 'DRIVER', 0);

INSERT INTO Exam (ExamID, PersonNumber, ExamDateTime, CenterName, AdminOfficerNumber, OverallScore, PassedFlag) VALUES
(1, 1, '2026-01-02 09:00:00', 'Capital Region DMV Testing Center', 1, 88.00, 1),
(2, 2, '2026-02-03 10:00:00', 'Capital Region DMV Testing Center', 2, 76.00, 1),
(3, 3, '2026-03-04 11:00:00', 'Capital Region DMV Testing Center', 3, 92.00, 1),
(4, 4, '2026-04-05 12:00:00', 'Capital Region DMV Testing Center', 4, 68.00, 0),
(5, 5, '2026-05-06 13:00:00', 'Capital Region DMV Testing Center', 5, 84.00, 1),
(6, 6, '2026-06-07 14:00:00', 'Capital Region DMV Testing Center', 6, 79.00, 1),
(7, 7, '2026-01-08 15:00:00', 'Capital Region DMV Testing Center', 7, 95.00, 1),
(8, 8, '2026-02-09 09:00:00', 'Capital Region DMV Testing Center', 8, 73.00, 1),
(9, 9, '2026-03-10 10:00:00', 'Capital Region DMV Testing Center', 1, 81.00, 1),
(10, 10, '2026-04-11 11:00:00', 'Capital Region DMV Testing Center', 2, 66.00, 0),
(11, 11, '2026-05-12 12:00:00', 'Capital Region DMV Testing Center', 3, 90.00, 1),
(12, 12, '2026-06-13 13:00:00', 'Capital Region DMV Testing Center', 4, 87.00, 1),
(13, 13, '2026-01-14 14:00:00', 'Capital Region DMV Testing Center', 5, 72.00, 1),
(14, 14, '2026-02-15 15:00:00', 'Capital Region DMV Testing Center', 6, 78.00, 1),
(15, 15, '2026-03-16 09:00:00', 'Capital Region DMV Testing Center', 7, 93.00, 1),
(16, 16, '2026-04-17 10:00:00', 'Capital Region DMV Testing Center', 8, 69.00, 0),
(17, 17, '2026-05-18 11:00:00', 'Capital Region DMV Testing Center', 1, 85.00, 1),
(18, 18, '2026-06-19 12:00:00', 'Capital Region DMV Testing Center', 2, 80.00, 1),
(19, 19, '2026-01-20 13:00:00', 'Capital Region DMV Testing Center', 3, 74.00, 1),
(20, 20, '2026-02-21 14:00:00', 'Capital Region DMV Testing Center', 4, 91.00, 1);

INSERT INTO ExamPart (ExamID, PartCode, PartScore, MaxScore) VALUES
(1, 'WRITTEN', 86.00, 100.00),
(1, 'ROAD_SIGNS', 92.00, 100.00),
(1, 'ROAD_TEST', 85.00, 100.00),
(2, 'WRITTEN', 78.00, 100.00),
(2, 'ROAD_SIGNS', 77.00, 100.00),
(2, 'ROAD_TEST', 68.00, 100.00),
(3, 'WRITTEN', 93.00, 100.00),
(3, 'ROAD_SIGNS', 87.00, 100.00),
(3, 'ROAD_TEST', 84.00, 100.00),
(4, 'WRITTEN', 67.00, 100.00),
(4, 'ROAD_SIGNS', 67.00, 100.00),
(4, 'ROAD_TEST', 75.00, 100.00),
(5, 'WRITTEN', 81.00, 100.00),
(5, 'ROAD_SIGNS', 85.00, 100.00),
(5, 'ROAD_TEST', 89.00, 100.00),
(6, 'WRITTEN', 78.00, 100.00),
(6, 'ROAD_SIGNS', 80.00, 100.00),
(6, 'ROAD_TEST', 75.00, 100.00),
(7, 'WRITTEN', 90.00, 100.00),
(7, 'ROAD_SIGNS', 90.00, 100.00),
(7, 'ROAD_TEST', 100.00, 100.00),
(8, 'WRITTEN', 68.00, 100.00),
(8, 'ROAD_SIGNS', 76.00, 100.00),
(8, 'ROAD_TEST', 66.00, 100.00),
(9, 'WRITTEN', 76.00, 100.00),
(9, 'ROAD_SIGNS', 81.00, 100.00),
(9, 'ROAD_TEST', 89.00, 100.00),
(10, 'WRITTEN', 65.00, 100.00),
(10, 'ROAD_SIGNS', 68.00, 100.00),
(10, 'ROAD_TEST', 67.00, 100.00),
(11, 'WRITTEN', 95.00, 100.00),
(11, 'ROAD_SIGNS', 90.00, 100.00),
(11, 'ROAD_TEST', 97.00, 100.00),
(12, 'WRITTEN', 83.00, 100.00),
(12, 'ROAD_SIGNS', 92.00, 100.00),
(12, 'ROAD_TEST', 89.00, 100.00),
(13, 'WRITTEN', 71.00, 100.00),
(13, 'ROAD_SIGNS', 69.00, 100.00),
(13, 'ROAD_TEST', 69.00, 100.00),
(14, 'WRITTEN', 77.00, 100.00),
(14, 'ROAD_SIGNS', 76.00, 100.00),
(14, 'ROAD_TEST', 83.00, 100.00),
(15, 'WRITTEN', 92.00, 100.00),
(15, 'ROAD_SIGNS', 97.00, 100.00),
(15, 'ROAD_TEST', 93.00, 100.00),
(16, 'WRITTEN', 74.00, 100.00),
(16, 'ROAD_SIGNS', 66.00, 100.00),
(16, 'ROAD_TEST', 75.00, 100.00),
(17, 'WRITTEN', 85.00, 100.00),
(17, 'ROAD_SIGNS', 87.00, 100.00),
(17, 'ROAD_TEST', 89.00, 100.00),
(18, 'WRITTEN', 79.00, 100.00),
(18, 'ROAD_SIGNS', 74.00, 100.00),
(18, 'ROAD_TEST', 77.00, 100.00),
(19, 'WRITTEN', 78.00, 100.00),
(19, 'ROAD_SIGNS', 74.00, 100.00),
(19, 'ROAD_TEST', 77.00, 100.00),
(20, 'WRITTEN', 87.00, 100.00),
(20, 'ROAD_SIGNS', 86.00, 100.00),
(20, 'ROAD_TEST', 99.00, 100.00);

-- Verification
SELECT 'Person' AS TableName, COUNT(*) AS RowCount FROM Person
UNION ALL SELECT 'Address', COUNT(*) FROM Address
UNION ALL SELECT 'License', COUNT(*) FROM License
UNION ALL SELECT 'Operator', COUNT(*) FROM Operator
UNION ALL SELECT 'Officer', COUNT(*) FROM Officer
UNION ALL SELECT 'Vehicle', COUNT(*) FROM Vehicle
UNION ALL SELECT 'VehicleOwner', COUNT(*) FROM VehicleOwner
UNION ALL SELECT 'TrafficCode', COUNT(*) FROM TrafficCode
UNION ALL SELECT 'Event', COUNT(*) FROM Event
UNION ALL SELECT 'Accident', COUNT(*) FROM Accident
UNION ALL SELECT 'Citation', COUNT(*) FROM Citation
UNION ALL SELECT 'CitationTrafficCode', COUNT(*) FROM CitationTrafficCode
UNION ALL SELECT 'VehicleEvent', COUNT(*) FROM VehicleEvent
UNION ALL SELECT 'PersonEvent', COUNT(*) FROM PersonEvent
UNION ALL SELECT 'Exam', COUNT(*) FROM Exam
UNION ALL SELECT 'ExamPart', COUNT(*) FROM ExamPart;

SELECT SUM(RowCount) AS TotalSeedRows
FROM (
    SELECT COUNT(*) AS RowCount FROM Person
    UNION ALL SELECT COUNT(*) FROM Address
    UNION ALL SELECT COUNT(*) FROM License
    UNION ALL SELECT COUNT(*) FROM Operator
    UNION ALL SELECT COUNT(*) FROM Officer
    UNION ALL SELECT COUNT(*) FROM Vehicle
    UNION ALL SELECT COUNT(*) FROM VehicleOwner
    UNION ALL SELECT COUNT(*) FROM TrafficCode
    UNION ALL SELECT COUNT(*) FROM Event
    UNION ALL SELECT COUNT(*) FROM Accident
    UNION ALL SELECT COUNT(*) FROM Citation
    UNION ALL SELECT COUNT(*) FROM CitationTrafficCode
    UNION ALL SELECT COUNT(*) FROM VehicleEvent
    UNION ALL SELECT COUNT(*) FROM PersonEvent
    UNION ALL SELECT COUNT(*) FROM Exam
    UNION ALL SELECT COUNT(*) FROM ExamPart
) AS counts;