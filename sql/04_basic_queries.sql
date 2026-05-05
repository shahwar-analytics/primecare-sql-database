
/*
==========================================================
 BASIC QUERIES & JOINS

Role Description:
This section includes basic SQL queries
used to retrieve and display data.

Tasks Completed:
- Created basic SELECT queries
- Implemented INNER JOIN queries
- Implemented LEFT JOIN queries
- Retrieved related data across tables
- Verified query accuracy and results

Purpose:
This step demonstrates how relational
tables are connected and how data
can be retrieved using JOIN operations.
==========================================================
*/

/* =======================================================
   STEP 1 — RETRIEVE BASIC DATA USING SELECT
   Retrieve basic information from individual tables to verify 
   stored records before performing joins.
======================================================= */
USE primecaredb;

SELECT 
	PatientID, 
    FirstName, 
    LastName, 
    Email
    
FROM patient;

SELECT 
	TherapistID, 
    FirstName, 
    LastName, 
    HourlyRate
    
FROM therapist;

/* =======================================================
   STEP 2 — DISPLAY APPOINTMENT DETAILS USING INNER JOIN
   Retrieve appointment records with matching patient and 
   therapist names
======================================================= */
   
SELECT
	a.AppointmentID,
    a.AppointmentDate,
    a.StartTime,
    a.EndTime,
    
    CONCAT(p.FirstName, ' ', p.Lastname) AS PatientName,
	CONCAT(t.FirstName, ' ', t.LastName) AS TherapistName

FROM appointment a
INNER JOIN patient p
	ON a.PatientID = p.PatientID
INNER JOIN therapist t
	ON a.TherapistID = t.TherapistID

ORDER BY a.appointmentDate;
   
/* =======================================================
   STEP 3 — DISPLAY PATIENTS WITH INSURANCE USING LEFT JOIN
   Retrieve all patients including those without insurance 
   information
======================================================= */
-- Insert a patient without insurance to demonstrate LEFT JOIN behaviour
INSERT INTO patient (PatientID, FirstName, LastName, DateOfBirth, Email, AddressID)
VALUES (9999, 'Test', 'NoInsurance', '2000-01-01', 'test@gmail.com', 1);

SELECT
	p.PatientID,
    CONCAT (p.FirstName, ' ', p.LastName) AS PatientName,
    i.ProviderName

FROM patient p
LEFT JOIN insurance i
	ON p.PatientID = i.PatientID;
    
-- Delete test data after verification

DELETE FROM patient
WHERE PatientID = 9999;


/* =======================================================
   STEP 4 — RETRIEVE RELATED DATA ACROSS MULTIPLE TABLES
   Retrieve appointment information including patient name, 
   therapist name, service provided, and appointment time 
   by joining multiple related tables.
   Note: Some appointments may appear multiple times 
   because they are associated with more than one service.
======================================================= */
   
SELECT 
    a.AppointmentID,
    a.AppointmentDate,
    a.StartTime,
    a.EndTime,

    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    CONCAT(t.FirstName, ' ', t.LastName) AS TherapistName,

    s.ServiceName

FROM appointment a
INNER JOIN patient p 
    ON a.PatientID = p.PatientID
INNER JOIN therapist t 
    ON a.TherapistID = t.TherapistID
INNER JOIN appointment_service aps 
    ON a.AppointmentID = aps.AppointmentID
INNER JOIN service s 
    ON aps.ServiceID = s.ServiceID

ORDER BY a.AppointmentDate;
   
/* =======================================================
   STEP 5 — VERIFY QUERY ACCURACY AND RESULTS
   Confirm that data relationships and query outputs are 
   consistent and correct
======================================================= */   
-- verify that each appointment is correctly linked to a patient
SELECT 
    a.AppointmentID,
    p.PatientID,
    p.FirstName,
    p.LastName
FROM appointment a
INNER JOIN patient p 
    ON a.PatientID = p.PatientID;
    
-- Verify that each appointment is correctly linked to a valid therapist 
SELECT 
    a.AppointmentID,
    t.TherapistID,
    t.FirstName,
    t.LastName
FROM appointment a
INNER JOIN therapist t
    ON a.TherapistID = t.TherapistID
ORDER BY AppointmentID; 

-- Verify patient and insurance relationship
SELECT 
    p.PatientID,
    p.FirstName,
    p.LastName,
    i.ProviderName
FROM patient p
LEFT JOIN insurance i
    ON p.PatientID = i.PatientID;

-- Verify that each appointment is correctly linked to its service records
SELECT 
    a.AppointmentID,
    s.ServiceID,
    s.ServiceName
FROM appointment a
INNER JOIN appointment_service aps
    ON a.AppointmentID = aps.AppointmentID
INNER JOIN service s
    ON aps.ServiceID = s.ServiceID
ORDER BY a.AppointmentID;
