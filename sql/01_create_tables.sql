
/*
==========================================================
PrimeCare Therapy Center Database


Project Description:
This project implements a complete SQL database system
based on the conceptual, enhanced, and normalized
database designs developed in Assignments 1–3.

The system supports the operations of PrimeCare Therapy
Center, including patient management, therapist records,
appointments, services, payments, and clinical data.

Project Components:
1. Database Creation (DDL)
2. Data Insertion (DML)
3. Data Manipulation (UPDATE / DELETE)
4. SQL Queries (JOIN, GROUP BY, Subqueries)
5. Transaction Management

==========================================================
*/


/*
==========================================================
DATABASE CREATION (DDL)


Role Description:
This section creates the database structure using SQL.
All tables are created based on the final 3NF schema
developed in previous assignments.

Tasks Completed:
- Created PrimeCareDB database
- Implemented all required tables
- Added Primary Keys and Foreign Keys
- Applied constraints:
    NOT NULL
    UNIQUE
    CHECK
- Defined ON DELETE and ON UPDATE actions
- Ensured correct table creation order to avoid
  foreign key dependency errors

This section provides the foundation for the rest
of the project including data insertion, queries,
and transaction management.
==========================================================
*/
/* =======================================================
   STEP 1 — CREATE DATABASE
   ======================================================= */

-- Create the main project database
CREATE DATABASE PrimeCareDB;

-- Select the database to work in
USE PrimeCareDB;

/* =======================================================
   STEP 2 — CREATE MAIN (PARENT) TABLES
   These tables do not depend on other tables
   ======================================================= */

-- Address table stores patient address details
CREATE TABLE Address (
    AddressID INT PRIMARY KEY,
    StreetAddress VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Province VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL
);


-- Patient table stores patient personal information
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    AddressID INT,

    -- Foreign key linking patient to address
    FOREIGN KEY (AddressID)
        REFERENCES Address(AddressID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);


-- Therapist table stores therapist information
CREATE TABLE Therapist (
    TherapistID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE,
    HourlyRate DECIMAL(8,2) NOT NULL CHECK (HourlyRate > 0),
    TherapistStatus VARCHAR(20) NOT NULL
);


-- Specialization table stores therapist specialization types
CREATE TABLE Specialization (
    SpecializationID INT PRIMARY KEY,
    SpecializationName VARCHAR(100) NOT NULL UNIQUE
);


-- Service table stores therapy service types
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    CPTCode VARCHAR(20) NOT NULL UNIQUE,
    DefaultRate DECIMAL(8,2) NOT NULL CHECK (DefaultRate >= 0)
);



/* =======================================================
   STEP 3 — CREATE CHILD TABLES
   These tables depend on parent tables
   ======================================================= */

-- Stores patient phone numbers
CREATE TABLE Patient_Phone (
    PhoneID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    PhoneType VARCHAR(20) NOT NULL,
    IsPrimary BOOLEAN NOT NULL,

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Stores therapist phone numbers
CREATE TABLE Therapist_Phone (
    PhoneID INT PRIMARY KEY,
    TherapistID INT NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    PhoneType VARCHAR(20) NOT NULL,

    FOREIGN KEY (TherapistID)
        REFERENCES Therapist(TherapistID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Bridge table linking therapist and specialization
CREATE TABLE Therapist_Specialization (
    TherapistID INT NOT NULL,
    SpecializationID INT NOT NULL,

    PRIMARY KEY (TherapistID, SpecializationID),

    FOREIGN KEY (TherapistID)
        REFERENCES Therapist(TherapistID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (SpecializationID)
        REFERENCES Specialization(SpecializationID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Appointment table stores patient appointments
CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    TherapistID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Status VARCHAR(20) NOT NULL,

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (TherapistID)
        REFERENCES Therapist(TherapistID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- Ensures appointment time validity
    CHECK (EndTime > StartTime)
);


-- Bridge table linking appointments and services
CREATE TABLE Appointment_Service (
    AppointmentID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    AppliedRate DECIMAL(8,2) NOT NULL CHECK (AppliedRate >= 0),

    PRIMARY KEY (AppointmentID, ServiceID),

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (ServiceID)
        REFERENCES Service(ServiceID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- Payment table stores payment records
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(8,2) NOT NULL CHECK (Amount >= 0),
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Insurance table stores patient insurance details
CREATE TABLE Insurance (
    InsuranceID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    ProviderName VARCHAR(100) NOT NULL,
    PolicyNumber VARCHAR(50) NOT NULL UNIQUE,
    CoveragePercent DECIMAL(5,2)
        NOT NULL CHECK (CoveragePercent >= 0 AND CoveragePercent <= 100),

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Stores emergency contact details
CREATE TABLE Emergency_Contact (
    ContactID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Relationship VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Stores diagnosis records
CREATE TABLE Diagnosis (
    DiagnosisID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    TherapistID INT NOT NULL,
    DiagnosisCode VARCHAR(20) NOT NULL,
    DiagnosisDate DATE NOT NULL,

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (TherapistID)
        REFERENCES Therapist(TherapistID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- Stores treatment plans
CREATE TABLE Treatment_Plan (
    PlanID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    PlanDescription TEXT NOT NULL,
    ConsentGiven BOOLEAN NOT NULL,

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- Stores clinical notes
CREATE TABLE Clinical_Note (
    NoteID INT PRIMARY KEY,
    AppointmentID INT NOT NULL UNIQUE,
    NoteText TEXT NOT NULL,
    NoteDate DATE NOT NULL,

    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

/* =======================================================
   FINAL STEP — VERIFY TABLE CREATION
   ======================================================= */

-- Show all created tables
SHOW TABLES;

DESCRIBE Patient;
