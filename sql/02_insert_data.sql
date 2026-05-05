
/* =======================================================
    DATA INSERTION 

   Role Description:
   This section inserts sample data into all tables
   created in the database.

   Tasks Completed:
   - Inserted at least 5 rows into each table
   - Ensured all data follows constraints
   - Maintained correct foreign key relationships
   - Used realistic sample data based on
     PrimeCare Therapy Center scenario
   - Verified successful data insertion

   ======================================================= */


/* =======================================================
   STEP 1 — SELECT DATABASE
   ======================================================= */

-- Use the existing database created in Person 1
USE PrimeCareDB;


/* =======================================================
   STEP 2 — INSERT INTO MAIN TABLES
   Insert into tables that do NOT depend on others first
   ======================================================= */

-- Insert into Address table
INSERT INTO Address VALUES
(1, '123 Main St', 'Toronto', 'ON', 'M1A1A1'),
(2, '456 Oak Ave', 'Montreal', 'QC', 'H1A1A1'),
(3, '789 Pine Rd', 'Vancouver', 'BC', 'V1A1A1'),
(4, '321 Maple St', 'Calgary', 'AB', 'T1A1A1'),
(5, '654 Cedar Ln', 'Ottawa', 'ON', 'K1A1A1');


-- Insert into Patient table
INSERT INTO Patient VALUES
(1001, 'Sarah', 'Lee', '1995-06-12', 'sarah@email.com', 1),
(1002, 'Marcus', 'Brown', '1990-03-22', 'marcus@email.com', 2),
(1003, 'Aisha', 'Khan', '1998-11-05', 'aisha@email.com', 3),
(1004, 'John', 'Smith', '1985-01-15', 'john@email.com', 4),
(1005, 'Emily', 'Davis', '2000-07-30', 'emily@email.com', 5);


-- Insert into Therapist table
INSERT INTO Therapist VALUES
(201, 'Alice', 'Johnson', 'LIC123', 'alice@email.com', 80, 'Active'),
(202, 'David', 'Miller', 'LIC456', 'david@email.com', 90, 'Active'),
(203, 'Sophia', 'Wilson', 'LIC789', 'sophia@email.com', 85, 'Inactive'),
(204, 'James', 'Taylor', 'LIC321', 'james@email.com', 75, 'Active'),
(205, 'Olivia', 'Anderson', 'LIC654', 'olivia@email.com', 95, 'Active');


-- Insert into Specialization table
INSERT INTO Specialization VALUES
(1, 'Physiotherapy'),
(2, 'Psychology'),
(3, 'Occupational Therapy'),
(4, 'Speech Therapy'),
(5, 'Rehabilitation');


-- Insert into Service table
INSERT INTO Service VALUES
(1, 'Individual Therapy', 'CPT001', 100),
(2, 'Family Therapy', 'CPT002', 120),
(3, 'Group Therapy', 'CPT003', 80),
(4, 'Assessment', 'CPT004', 150),
(5, 'Rehabilitation Session', 'CPT005', 110);


/* =======================================================
   STEP 3 — INSERT INTO CHILD TABLES
   These tables depend on parent tables
   ======================================================= */

-- Insert into Patient_Phone table
INSERT INTO Patient_Phone VALUES
(1, 1001, '613-555-0101', 'Mobile', TRUE),
(2, 1001, '613-555-0102', 'Home', FALSE),
(3, 1002, '416-555-0111', 'Mobile', TRUE),
(4, 1003, '514-555-0121', 'Mobile', TRUE),
(5, 1004, '403-555-0131', 'Mobile', TRUE);


-- Insert into Therapist_Phone table
INSERT INTO Therapist_Phone VALUES
(1, 201, '111-222-3333', 'Work'),
(2, 202, '222-333-4444', 'Work'),
(3, 203, '333-444-5555', 'Work'),
(4, 204, '444-555-6666', 'Work'),
(5, 205, '555-666-7777', 'Work');


-- Insert into Therapist_Specialization table
INSERT INTO Therapist_Specialization VALUES
(201, 1),
(202, 2),
(203, 3),
(204, 4),
(205, 5);


-- Insert into Appointment table
INSERT INTO Appointment VALUES
(3001, 1001, 201, '2026-04-01', '10:00:00', '11:00:00', 'Completed'),
(3002, 1002, 202, '2026-04-02', '11:00:00', '12:00:00', 'Scheduled'),
(3003, 1003, 201, '2026-04-03', '09:00:00', '10:00:00', 'Completed'),
(3004, 1004, 204, '2026-04-04', '14:00:00', '15:00:00', 'Cancelled'),
(3005, 1005, 205, '2026-04-05', '13:00:00', '14:00:00', 'Completed');


-- Insert into Appointment_Service table
INSERT INTO Appointment_Service VALUES
(3001, 1, 1, 100),
(3001, 4, 1, 150),
(3002, 2, 1, 120),
(3003, 3, 1, 80),
(3005, 5, 1, 110);


-- Insert into Payment table
INSERT INTO Payment VALUES
(1, 3001, 250, '2026-04-01', 'Credit Card'),
(2, 3002, 120, '2026-04-02', 'Cash'),
(3, 3003, 80, '2026-04-03', 'Debit'),
(4, 3004, 0, '2026-04-04', 'Cash'),
(5, 3005, 110, '2026-04-05', 'Credit Card');


-- Insert into Insurance table
INSERT INTO Insurance VALUES
(1, 1001, 'SunLife', 'POL123', 80),
(2, 1002, 'Manulife', 'POL456', 70),
(3, 1003, 'BlueCross', 'POL789', 90),
(4, 1004, 'SunLife', 'POL321', 75),
(5, 1005, 'Manulife', 'POL654', 85);


-- Insert into Emergency_Contact table
INSERT INTO Emergency_Contact VALUES
(1, 1001, 'John', 'Lee', 'Father', '111-111-1111'),
(2, 1002, 'Anna', 'Brown', 'Sister', '222-222-2222'),
(3, 1003, 'Ali', 'Khan', 'Brother', '333-333-3333'),
(4, 1004, 'Mary', 'Smith', 'Mother', '444-444-4444'),
(5, 1005, 'Chris', 'Davis', 'Friend', '555-555-5555');


-- Insert into Diagnosis table
INSERT INTO Diagnosis VALUES
(1, 1001, 201, 'D001', '2026-04-01'),
(2, 1002, 202, 'D002', '2026-04-02'),
(3, 1003, 201, 'D003', '2026-04-03'),
(4, 1004, 204, 'D004', '2026-04-04'),
(5, 1005, 205, 'D005', '2026-04-05');


-- Insert into Treatment_Plan table
INSERT INTO Treatment_Plan VALUES
(1, 1001, 'Weekly therapy sessions', TRUE),
(2, 1002, 'Family counseling', TRUE),
(3, 1003, 'Group therapy plan', FALSE),
(4, 1004, 'Rehabilitation program', TRUE),
(5, 1005, 'Speech therapy sessions', TRUE);


-- Insert into Clinical_Note table
INSERT INTO Clinical_Note VALUES
(1, 3001, 'Patient improving well', '2026-04-01'),
(2, 3002, 'Initial consultation', '2026-04-02'),
(3, 3003, 'Good progress', '2026-04-03'),
(4, 3004, 'Appointment cancelled', '2026-04-04'),
(5, 3005, 'Therapy successful', '2026-04-05');


/* =======================================================
   FINAL STEP — VERIFY DATA INSERTION
   ======================================================= */

-- Check inserted data
SELECT * FROM Patient;
SELECT * FROM Appointment;
SELECT * FROM Payment;
