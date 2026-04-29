-- The Staging table is split into 4 focused tables:
-- 1. customers    : Demographic & location info
-- 2. subscription : services & contract details
-- 3. billing      : charges & payment info
-- 4. churn_status : churn_labels, scores & reasons


-- ------------------------------------------------
-- Table 1: customers
-- Stores customers demographic and location data
-- ------------------------------------------------
CREATE TABLE customers (
    CustomerID VARCHAR(50) PRIMARY KEY,
    Gender VARCHAR(10),
    SeniorCitizen TINYINT(1),
    Partner TINYINT(1),
    Dependents TINYINT(1),
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(100),
    ZipCode VARCHAR(20),
    Latitude DECIMAL(10,6),
    Longitude DECIMAL(10,6)
);



-- ---------------------------------------------------
-- Table 2: subscription
-- stores service and contract details per customer
-- ---------------------------------------------------
CREATE TABLE subscriptions (
    CustomerID VARCHAR(50) PRIMARY KEY,
    TenureMonths INT,
    PhoneService TINYINT(1),
    MultipleLines TINYINT(1),
    InternetService VARCHAR(20),
    OnlineSecurity TINYINT(1),
    OnlineBackup TINYINT(1),
    DeviceProtection TINYINT(1),
    TechSupport TINYINT(1),
    StreamingTV TINYINT(1),
    StreamingMovies TINYINT(1),
    Contract VARCHAR(20),
    PaperlessBilling TINYINT(1),
    PaymentMethod VARCHAR(50)
);




-- -----------------------------------------------
-- Table 3: billing
-- stores monthly and total charges per customer
-- -----------------------------------------------
CREATE TABLE billing (
    CustomerID VARCHAR(50) PRIMARY KEY,
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2)
);



-- ----------------------------------------------
-- Table 4: churn_status
-- Stores churn outcome, score, CLTV and reason
-- ----------------------------------------------
CREATE TABLE churn_status (
    CustomerID VARCHAR(50) PRIMARY KEY,
    ChurnLabel TINYINT(1),
    ChurnValue INT,
    ChurnScore INT,
    CLTV INT,
    ChurnReason VARCHAR(255)
);