


/*
==========================================================
 ADVANCED QUERIES

Role Description:
This section includes advanced SQL queries
used for analysis and business reporting.

Tasks Completed:
- Created GROUP BY queries
- Used aggregate functions:
    COUNT()
    SUM()
    AVG()
- Implemented subqueries
- Developed business-answer queries
- Generated summarized results
  from multiple tables

Purpose:
This step demonstrates how database
information can be analyzed and used
to support business decision-making.
==========================================================
*/

/* =======================================================
   QUERY 1 — COUNT APPOINTMENTS PER THERAPIST
   Business Question: How many appointments has each 
   therapist handled?
   Uses: GROUP BY, COUNT(), JOIN
   ======================================================= */
   USE primecaredb;

SELECT
    t.TherapistID,
    CONCAT(t.FirstName, ' ', t.LastName) AS TherapistName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Therapist t
LEFT JOIN Appointment a
    ON t.TherapistID = a.TherapistID
GROUP BY t.TherapistID, t.FirstName, t.LastName
ORDER BY TotalAppointments DESC;

/* Expected Business Insight:
   Shows workload distribution across therapists.
   Helps management identify over/under-utilized therapists. */

/* =======================================================
   QUERY 2 — TOTAL REVENUE PER THERAPIST
   Business Question: How much revenue has each therapist 
   generated for the clinic?
   Uses: GROUP BY, SUM(), JOIN
   ======================================================= */

SELECT
    t.TherapistID,
    CONCAT(t.FirstName, ' ', t.LastName) AS TherapistName,
    SUM(py.Amount) AS TotalRevenue
FROM Therapist t
JOIN Appointment a
    ON t.TherapistID = a.TherapistID
JOIN Payment py
    ON a.AppointmentID = py.AppointmentID
GROUP BY t.TherapistID, t.FirstName, t.LastName
ORDER BY TotalRevenue DESC;

/* =======================================================
   QUERY 3 — AVERAGE PAYMENT AMOUNT PER PAYMENT METHOD
   Business Question: What is the average amount paid 
   per payment method?
   Uses: GROUP BY, AVG(), ROUND()
   ======================================================= */

SELECT
    PaymentMethod,
    COUNT(*) AS NumberOfPayments,
    ROUND(AVG(Amount), 2) AS AverageAmount,
    SUM(Amount) AS TotalAmount
FROM Payment
GROUP BY PaymentMethod
ORDER BY TotalAmount DESC;

/* =======================================================
   QUERY 4 — APPOINTMENT STATUS SUMMARY
   Business Question: How many appointments are Completed, 
   Scheduled, and Cancelled?
   Uses: GROUP BY, COUNT()
   ======================================================= */

SELECT
    Status,
    COUNT(*) AS NumberOfAppointments
FROM Appointment
GROUP BY Status
ORDER BY NumberOfAppointments DESC;

/* =======================================================
   QUERY 5 — TOTAL REVENUE PER MONTH
   Business Question: How does revenue trend month by month?
   Uses: GROUP BY, SUM(), DATE functions
   ======================================================= */

SELECT
    YEAR(PaymentDate)  AS PaymentYear,
    MONTH(PaymentDate) AS PaymentMonth,
    COUNT(*)           AS NumberOfPayments,
    SUM(Amount)        AS MonthlyRevenue
FROM Payment
GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
ORDER BY PaymentYear, PaymentMonth;

/* =======================================================
   QUERY 6 — SERVICES MOST FREQUENTLY USED
   Business Question: Which services are most popular 
   at PrimeCare?
   Uses: GROUP BY, COUNT(), JOIN
   ======================================================= */

SELECT
    s.ServiceID,
    s.ServiceName,
    s.CPTCode,
    COUNT(aps.AppointmentID) AS TimesUsed,
    SUM(aps.Quantity)        AS TotalQuantity,
    SUM(aps.AppliedRate)     AS TotalBilled
FROM Service s
LEFT JOIN Appointment_Service aps
    ON s.ServiceID = aps.ServiceID
GROUP BY s.ServiceID, s.ServiceName, s.CPTCode
ORDER BY TimesUsed DESC;

/* =======================================================
   QUERY 7 — SUBQUERY: PATIENTS WHO PAID MORE THAN AVERAGE
   Business Question: Which patients have paid above the 
   clinic's average payment amount?
   Uses: Subquery, JOIN, SUM(), AVG()
   ======================================================= */

SELECT
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    SUM(py.Amount) AS TotalPaid
FROM Patient p
JOIN Appointment a
    ON p.PatientID = a.PatientID
JOIN Payment py
    ON a.AppointmentID = py.AppointmentID
GROUP BY p.PatientID, p.FirstName, p.LastName
HAVING SUM(py.Amount) > (
    SELECT AVG(Amount) FROM Payment
)
ORDER BY TotalPaid DESC;

/* =======================================================
   QUERY 8 — SUBQUERY: THERAPISTS WITH ABOVE-AVERAGE 
   HOURLY RATE
   Business Question: Which therapists earn more than the 
   average hourly rate at PrimeCare?
   Uses: Subquery, comparison operator
   ======================================================= */

SELECT
    TherapistID,
    CONCAT(FirstName, ' ', LastName) AS TherapistName,
    HourlyRate,
    TherapistStatus
FROM Therapist
WHERE HourlyRate > (
    SELECT AVG(HourlyRate) FROM Therapist
)
ORDER BY HourlyRate DESC;

/* =======================================================
   QUERY 9 — INSURANCE COVERAGE SUMMARY PER PROVIDER
   Business Question: How many patients does each 
   insurance provider cover, and what is the average 
   coverage percentage?
   Uses: GROUP BY, COUNT(), AVG()
   ======================================================= */

SELECT
    ProviderName,
    COUNT(PatientID)              AS NumberOfPatients,
    ROUND(AVG(CoveragePercent),2) AS AvgCoveragePercent,
    MIN(CoveragePercent)          AS MinCoverage,
    MAX(CoveragePercent)          AS MaxCoverage
FROM Insurance
GROUP BY ProviderName
ORDER BY NumberOfPatients DESC;

/* =======================================================
   QUERY 10 — BUSINESS SUMMARY REPORT
   Business Question: Give a full performance overview —
   total patients, appointments, revenue, and average payment
   Uses: COUNT(), SUM(), AVG() — no GROUP BY (single row)
   ======================================================= */

SELECT
    (SELECT COUNT(*) FROM Patient)     AS TotalPatients,
    (SELECT COUNT(*) FROM Therapist 
     WHERE TherapistStatus = 'Active') AS ActiveTherapists,
    (SELECT COUNT(*) FROM Appointment) AS TotalAppointments,
    (SELECT COUNT(*) FROM Appointment 
     WHERE Status = 'Completed')       AS CompletedAppointments,
    (SELECT SUM(Amount) FROM Payment)  AS TotalRevenue,
    (SELECT ROUND(AVG(Amount),2) 
     FROM Payment)                     AS AvgPaymentAmount;
