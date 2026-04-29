-- Created the staging table to hold raw CSV data

CREATE TABLE staging_churn (
    CustomerID VARCHAR(50),
    Count INT,
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(100),
    ZipCode VARCHAR(20),
    LatLong VARCHAR(50),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6),
    Gender VARCHAR(10),
    SeniorCitizen VARCHAR(10),
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    TenureMonths INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges VARCHAR(50),
    ChurnLabel VARCHAR(10),
    ChurnValue INT,
    ChurnScore INT,
    CLTV INT,
    ChurnReason VARCHAR(255)
);

-- NOTE: After creating the table, the CSV file was imported
-- using MySQL Workbench's Table Data Import Wizard
-- Dataset: customer_churn_analysis.csv
-- Total records imported: 7043
 
-- To Verify the import
select * from staging_churn;
SELECT COUNT(*) as rows_count FROM staging_churn;