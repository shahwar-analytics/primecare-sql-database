
/*
==========================================================
 DATA MANIPULATION & TRANSACTIONS

Role Description:
This section performs data manipulation
operations and demonstrates transaction
management.

Tasks Completed:
- Created UPDATE statements
- Created DELETE statements
- Added additional INSERT operations
- Demonstrated transaction control:
    START TRANSACTION
    COMMIT
    ROLLBACK
- Tested data consistency after operations

Purpose:
This step demonstrates how database changes
can be safely applied and controlled using
transaction management.

/* =======================================================
   STEP 1 — SELECT DATABASE
   ======================================================= */

USE PrimeCareDB;


/* =======================================================
   STEP 2 — UPDATE STATEMENTS
   Modify existing records across multiple tables
   ======================================================= */

-- Update 1: Increase hourly rate for active therapists by 10%
UPDATE Therapist
SET HourlyRate = HourlyRate * 1.10
WHERE TherapistStatus = 'Active';

-- Verify the change
SELECT TherapistID, FirstName, LastName, HourlyRate, TherapistStatus
FROM Therapist;


-- Update 2: Change therapist Sophia Wilson status from Inactive to Active
UPDATE Therapist
SET TherapistStatus = 'Active'
WHERE TherapistID = 203;

-- Verify the change
SELECT TherapistID, FirstName, LastName, TherapistStatus
FROM Therapist
WHERE TherapistID = 203;


-- Update 3: Update appointment status from Scheduled to Completed
-- (Appointment 3002 — Marcus Brown with David Miller)
UPDATE Appointment
SET Status = 'Completed'
WHERE AppointmentID = 3002
  AND Status = 'Scheduled';

-- Verify the change
SELECT AppointmentID, Status
FROM Appointment
WHERE AppointmentID = 3002;


-- Update 4: Update patient email address
UPDATE Patient
SET Email = 'sarah.lee.updated@email.com'
WHERE PatientID = 1001;

-- Verify the change
SELECT PatientID, FirstName, LastName, Email
FROM Patient
WHERE PatientID = 1001;


-- Update 5: Update insurance coverage percentage for patient 1003
UPDATE Insurance
SET CoveragePercent = 95.00
WHERE PatientID = 1003
  AND ProviderName = 'BlueCross';

-- Verify the change
SELECT * FROM Insurance
WHERE PatientID = 1003;


/* =======================================================
   STEP 3 — DELETE STATEMENTS
   Remove records while respecting foreign key constraints
   ======================================================= */

-- Delete 1: Remove the cancelled appointment payment (Amount = 0)
-- Safe to delete since it has no meaningful financial record
DELETE FROM Payment
WHERE AppointmentID = 3004
  AND Amount = 0;

-- Verify deletion
SELECT * FROM Payment;


-- Delete 2: Remove a specific patient phone number (secondary number)
-- Patient 1001 has two phones — remove the Home number
DELETE FROM Patient_Phone
WHERE PatientID = 1001
  AND PhoneType = 'Home';

-- Verify deletion
SELECT * FROM Patient_Phone
WHERE PatientID = 1001;


-- Delete 3: Remove a therapist specialization assignment
-- Therapist 203 (Sophia Wilson) — remove Occupational Therapy specialization
DELETE FROM Therapist_Specialization
WHERE TherapistID = 203
  AND SpecializationID = 3;

-- Verify deletion
SELECT * FROM Therapist_Specialization;


/* =======================================================
   STEP 4 — ADDITIONAL INSERT OPERATIONS
   Add new records to reflect realistic clinic activity
   ======================================================= */

-- Insert 1: Add a new patient
INSERT INTO Address VALUES
(6, '900 Birch Blvd', 'Edmonton', 'AB', 'E1A1A1');

INSERT INTO Patient VALUES
(1006, 'Liam', 'Nguyen', '1993-08-18', 'liam@email.com', 6);

-- Insert 2: Add phone for new patient
INSERT INTO Patient_Phone VALUES
(6, 1006, '780-555-0141', 'Mobile', TRUE);

-- Insert 3: Add emergency contact for new patient
INSERT INTO Emergency_Contact VALUES
(6, 1006, 'Hana', 'Nguyen', 'Spouse', '780-555-0142');

-- Insert 4: Add insurance for new patient
INSERT INTO Insurance VALUES
(6, 1006, 'BlueCross', 'POL987', 80.00);

-- Insert 5: Add a new appointment for new patient
INSERT INTO Appointment VALUES
(3006, 1006, 202, '2026-04-10', '10:00:00', '11:00:00', 'Scheduled');

-- Insert 6: Link appointment to a service
INSERT INTO Appointment_Service VALUES
(3006, 1, 1, 100.00);

-- Insert 7: Add clinical note for new appointment
INSERT INTO Clinical_Note VALUES
(6, 3006, 'First session with new patient Liam Nguyen', '2026-04-10');

-- Verify new data
SELECT * FROM Patient WHERE PatientID = 1006;
SELECT * FROM Appointment WHERE AppointmentID = 3006;


/* =======================================================
   STEP 5 — TRANSACTION 1 (COMMIT)
   Record a new completed appointment with payment
   This transaction succeeds and is permanently saved
   ======================================================= */

START TRANSACTION;

    -- Step A: Insert new appointment for patient 1004
    INSERT INTO Appointment VALUES
    (3007, 1004, 205, '2026-04-11', '09:00:00', '10:00:00', 'Completed');

    -- Step B: Link service to the appointment
    INSERT INTO Appointment_Service VALUES
    (3007, 5, 1, 110.00);

    -- Step C: Record payment for the appointment
    INSERT INTO Payment VALUES
    (6, 3007, 110.00, '2026-04-11', 'Debit');

    -- Step D: Add clinical note
    INSERT INTO Clinical_Note VALUES
    (7, 3007, 'Patient John Smith completed rehabilitation session', '2026-04-11');

-- All steps succeeded — save permanently
COMMIT;

-- Verify committed transaction
SELECT a.AppointmentID, p.FirstName, p.LastName,
       a.AppointmentDate, a.Status,
       py.Amount, py.PaymentMethod
FROM Appointment a
JOIN Patient p ON a.PatientID = p.PatientID
JOIN Payment py ON a.AppointmentID = py.AppointmentID
WHERE a.AppointmentID = 3007;


/* =======================================================
   STEP 6 — TRANSACTION 2 (ROLLBACK)
   Simulate an error scenario where a payment amount
   is invalid — the transaction is rolled back entirely
   ======================================================= */

START TRANSACTION;

    -- Step A: Insert a new appointment
    INSERT INTO Appointment VALUES
    (3008, 1002, 203, '2026-04-12', '14:00:00', '15:00:00', 'Completed');

    -- Step B: Link service to the appointment
    INSERT INTO Appointment_Service VALUES
    (3008, 2, 1, 120.00);

  /*  -- Step C: Attempt to insert an INVALID payment amount (-50)
    -- This violates the CHECK (Amount >= 0) constraint
    -- In a real scenario this would trigger an error
    -- We simulate catching the error and rolling back
    INSERT INTO Payment VALUES
    (7, 3008, -50.00, '2026-04-12', 'Cash');

-- Something went wrong — undo all changes in this transaction
ROLLBACK; */

-- Verify rollback: appointment 3008 should NOT exist
SELECT * FROM Appointment WHERE AppointmentID = 3008;
SELECT * FROM Payment WHERE PaymentID = 7;


/* =======================================================
   STEP 7 — TRANSACTION 3 (COMMIT)
   Update therapist status and log a diagnosis safely
   Both operations must succeed together or not at all
   ======================================================= */

START TRANSACTION;

    -- Step A: Assign new specialization to therapist 203
    INSERT INTO Therapist_Specialization VALUES
    (203, 2);

    -- Step B: Record a new diagnosis linked to therapist 203
    INSERT INTO Diagnosis VALUES
    (6, 1006, 203, 'D006', '2026-04-10');

    -- Step C: Add a treatment plan for new patient
    INSERT INTO Treatment_Plan VALUES
    (6, 1006, 'Bi-weekly psychology sessions with progress tracking', TRUE);

-- All steps successful — commit permanently
COMMIT;

-- Verify all three changes
SELECT * FROM Therapist_Specialization WHERE TherapistID = 203;
SELECT * FROM Diagnosis WHERE PatientID = 1006;
SELECT * FROM Treatment_Plan WHERE PatientID = 1006;


/* =======================================================
   FINAL STEP — VERIFY DATA CONSISTENCY
   Confirm database state after all manipulations
   ======================================================= */

-- Final check: all patients
SELECT * FROM Patient;

-- Final check: all appointments with their status
SELECT AppointmentID, PatientID, TherapistID,
       AppointmentDate, Status
FROM Appointment
ORDER BY AppointmentDate;

-- Final check: all payments
SELECT * FROM Payment
ORDER BY PaymentDate;

-- Final check: all therapists with updated rates
SELECT TherapistID, FirstName, LastName,
       HourlyRate, TherapistStatus
FROM Therapist;

