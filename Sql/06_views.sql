-- ---------------------------------------------------------------------------
-- In this project, instead of connecting raw tables directly to Power BI,
-- I created views that combine all 4 tables (customers, subscriptions,
-- billing, churn_status) using JOINs. This makes it easier for me  to build
-- visuals in Power BI without writing complex queries there.
-- ----------------------------------------------------------------------------

-- -----------------------------------------------
-- View 1: vw_churn_full
-- Full joined view of all customer data
-- -----------------------------------------------
CREATE VIEW vw_churn_full AS
SELECT 
    c.CustomerID, c.Gender, c.SeniorCitizen, c.Partner, c.Dependents,
    c.Country, c.State, c.City,
    s.TenureMonths, s.Contract, s.InternetService, s.PaymentMethod,
    s.PhoneService, s.StreamingTV, s.StreamingMovies,
    b.MonthlyCharges, b.TotalCharges,
    cs.ChurnLabel, cs.ChurnValue, cs.ChurnScore, cs.CLTV, cs.ChurnReason
FROM customers c
JOIN subscriptions s ON c.CustomerID = s.CustomerID
JOIN billing b ON c.CustomerID = b.CustomerID
JOIN churn_status cs ON c.CustomerID = cs.CustomerID;

-- Preview
SELECT * FROM vw_churn_full;

-- -----------------------------------------------
-- View 2: vw_churn_summary
-- Aggregated summary by Contract, Internet Service & Payment Method
-- -----------------------------------------------
CREATE VIEW vw_churn_summary AS
SELECT 
    s.Contract,
    s.InternetService,
    s.PaymentMethod,
    COUNT(*) AS TotalCustomers,
    SUM(cs.ChurnValue) AS ChurnedCustomers,
    ROUND(SUM(cs.ChurnValue) * 100.0 / COUNT(*), 2) AS ChurnRate,
    SUM(b.MonthlyCharges) AS TotalMonthlyRevenue,
    SUM(CASE WHEN cs.ChurnLabel = 1 THEN b.MonthlyCharges ELSE 0 END) AS RevenueLost
FROM customers c
JOIN subscriptions s ON c.CustomerID = s.CustomerID
JOIN billing b ON c.CustomerID = b.CustomerID
JOIN churn_status cs ON c.CustomerID = cs.CustomerID
GROUP BY s.Contract, s.InternetService, s.PaymentMethod;

-- Preview
SELECT * FROM vw_churn_summary;

-- -----------------------------------------------
-- View 3: vw_high_risk_customers
-- Active customers with ChurnScore >= 70
-- -----------------------------------------------
CREATE VIEW vw_high_risk_customers AS
SELECT 
    c.CustomerID, c.State, c.City,
    s.Contract, s.TenureMonths,
    b.MonthlyCharges, cs.ChurnScore, cs.CLTV, cs.ChurnReason
FROM customers c
JOIN subscriptions s ON c.CustomerID = s.CustomerID
JOIN billing b ON c.CustomerID = b.CustomerID
JOIN churn_status cs ON c.CustomerID = cs.CustomerID
WHERE cs.ChurnScore >= 70 AND cs.ChurnLabel = 0;

-- Preview
select * from vw_high_risk_customers;