-- -----------------------------------------------
-- Q1. Overall Churn Rate
-- what percentage of customers have churned
-- -----------------------------------------------
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ChurnLabel = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN ChurnLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM churn_status;

-- -----------------------------------------------
-- Q2. Churn by Contract Type
-- Do month-to-month customers churn more?
-- -------------------------------------------------
SELECT 
    s.Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM subscriptions s
JOIN churn_status cs USING (CustomerID)
GROUP BY s.Contract
ORDER BY churn_rate DESC;

-- -----------------------------------------------
-- Q3.Churn by Tenure Group
-- Do newer customers churn more than long term ones?
-- -----------------------------------------------
SELECT 
    CASE 
        WHEN TenureMonths <= 6 THEN '0-6 Months'
        WHEN TenureMonths <= 12 THEN '6-12 Months'
        WHEN TenureMonths <= 24 THEN '12-24 Months'
        ELSE '24+ Months'
    END AS tenure_group,
    COUNT(*) AS total,
    SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM subscriptions s
JOIN churn_status cs ON s.CustomerID = cs.CustomerID
GROUP BY tenure_group;

-- -----------------------------------------------
-- Q4.Churn by Payment Method
-- Which payment method has the highest churn?
-- -----------------------------------------------
SELECT 
    s.PaymentMethod,
    COUNT(*) AS total,
    SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM subscriptions s
JOIN churn_status cs ON s.CustomerID = cs.CustomerID
GROUP BY s.PaymentMethod
ORDER BY churn_rate DESC;

-- ----------------------------------------------------------
-- Q5.Revenue Lost Due to Churn 
-- How much monthly revenue is lost from churned customers?
-- ----------------------------------------------------------
SELECT 
    ROUND(SUM(b.MonthlyCharges), 2) AS revenue_lost
FROM billing b
JOIN churn_status cs ON b.CustomerID = cs.CustomerID
WHERE cs.ChurnLabel = 1;

-- -----------------------------------------------
-- 6.Top Churn Reasons (WHY customers leave)
-- Why are customers actually leaving?
-- -----------------------------------------------
SELECT 
    ChurnReason,
    COUNT(*) AS total_customers
FROM churn_status
WHERE ChurnLabel = 1
AND ChurnReason IS NOT NULL
GROUP BY ChurnReason
ORDER BY total_customers DESC
LIMIT 10;

-- -----------------------------------------------
-- 7.High-Risk Customers
-- customers with churnscore >= 70 who are still active
-- These are priority targets for retention efforts
-- -----------------------------------------------
SELECT 
    cs.CustomerID,
    cs.ChurnScore,
    cs.CLTV,
    s.Contract,
    s.PaymentMethod,
    b.MonthlyCharges
FROM
    churn_status cs
        JOIN
    subscriptions s ON cs.CustomerID = s.CustomerID
        JOIN
    billing b ON cs.CustomerID = b.CustomerID
WHERE
    cs.ChurnLabel = 0 AND cs.ChurnScore >= 70
ORDER BY cs.ChurnScore DESC
LIMIT 20;

-- -----------------------------------------------------------
-- Q8. churn by Internet service type
-- -----------------------------------------------
SELECT 
    s.InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) AS churned,
    ROUND(100 * SUM(CASE WHEN cs.ChurnLabel = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM subscriptions s
JOIN churn_status cs ON s.CustomerID = cs.CustomerID
GROUP BY s.InternetService
ORDER BY churn_rate DESC;