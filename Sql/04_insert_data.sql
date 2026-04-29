-- NOTE: Yes/No string values from staging are
-- converted to TINYINT (1/0) during insert
-- TotalCharges is cast to DECIMAL (some blanks handled with NULLIF)

-- -----------------------------------------------
-- Insert into customers
-- -----------------------------------------------
INSERT INTO customers
SELECT
    CustomerID,
    Gender,
    (SeniorCitizen = 'Yes'),
    (Partner = 'Yes'),
    (Dependents = 'Yes'),
    Country,
    State,
    City,
    ZipCode,
    Latitude,
    Longitude
FROM staging_churn;



-- -----------------------------------------------
-- Insert into subscriptions
-- -----------------------------------------------
INSERT INTO subscriptions
SELECT
    CustomerID,
    TenureMonths,
    (PhoneService = 'Yes'),
    (MultipleLines = 'Yes'),
    InternetService,
    (OnlineSecurity = 'Yes'),
    (OnlineBackup = 'Yes'),
    (DeviceProtection = 'Yes'),
    (TechSupport = 'Yes'),
    (StreamingTV = 'Yes'),
    (StreamingMovies = 'Yes'),
    Contract,
    (PaperlessBilling = 'Yes'),
    PaymentMethod
FROM staging_churn;



-- -----------------------------------------------
-- Insert into billing
-- TotalCharges stored as VARCHAR in staging,
-- so we trim and cast it safely to DECIMAL
-- -----------------------------------------------
INSERT INTO billing (CustomerID, MonthlyCharges, TotalCharges)
SELECT
    CustomerID,
    MonthlyCharges,
    CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2))
FROM staging_churn;




-- -----------------------------------------------
-- Insert into churn_status
-- Empty ChurnReason values stored as NULL
-- -----------------------------------------------
INSERT INTO churn_status
SELECT
    CustomerID,
    (ChurnLabel = 'Yes'),
    ChurnValue,
    ChurnScore,
    CLTV,
    NULLIF(ChurnReason, '')
FROM staging_churn;



-- -----------------------------------------------
-- To Verify row counts in all 4 tables
-- All should show 7043 records
-- -----------------------------------------------
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM subscriptions;
SELECT COUNT(*) FROM billing;
SELECT COUNT(*) FROM churn_status;