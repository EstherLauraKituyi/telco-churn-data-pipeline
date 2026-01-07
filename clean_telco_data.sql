CREATE TABLE telco_churn_staging (
    "CustomerID" TEXT, "Count" TEXT, "Country" TEXT, "State" TEXT, "City" TEXT, 
    "Zip Code" TEXT, "Lat Long" TEXT, "Latitude" TEXT, "Longitude" TEXT, 
    "Gender" TEXT, "Senior Citizen" TEXT, "Partner" TEXT, "Dependents" TEXT, 
    "Tenure Months" TEXT, "Phone Service" TEXT, "Multiple Lines" TEXT, 
    "Internet Service" TEXT, "Online Security" TEXT, "Online Backup" TEXT, 
    "Device Protection" TEXT, "Tech Support" TEXT, "Streaming TV" TEXT, 
    "Streaming Movies" TEXT, "Contract" TEXT, "Paperless Billing" TEXT, 
    "Payment Method" TEXT, "Monthly Charges" TEXT, "Total Charges" TEXT, 
    "Churn Label" TEXT, "Churn Value" TEXT, "Churn Score" TEXT, 
    "CLTV" TEXT, "Churn Reason" TEXT
);

CREATE TABLE telco_churn_data AS
SELECT
    "CustomerID" AS customer_id,
    "Gender" AS gender,
    "Contract" AS contract_type,
    "Internet Service" AS internet_service,
    "Tech Support" AS tech_support,
    CAST(NULLIF(TRIM("Tenure Months"), '') AS INT) AS tenure,
    CAST(NULLIF(TRIM("Monthly Charges"), '') AS NUMERIC(10,2)) AS monthly_charges,
    CAST(NULLIF(TRIM("Total Charges"), '') AS NUMERIC(10,2)) AS total_charges,
    "Churn Label" AS churn_label
FROM
    telco_churn_staging;

--how your "Customer Service" experience at T-Mobile connects to the data:
SELECT COUNT(*) FROM telco_churn_data;	
SELECT 
    churn_label,
    COUNT(*) as total_customers,
    ROUND(AVG(tenure), 2) as avg_tenure_months,
    ROUND(AVG(monthly_charges), 2) as avg_monthly_bill
FROM telco_churn_data
GROUP BY churn_label;

--Which contracts are "Churn Magnets"?
SELECT 
    contract_type, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM telco_churn_data
GROUP BY contract_type
ORDER BY churn_rate_percentage DESC;

--Does "Tech Support" actually reduce churn?
SELECT 
    tech_support, 
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percentage
FROM telco_churn_data
GROUP BY tech_support;

--Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn_label = 'Yes' THEN 1.0 ELSE 0.0 END) / COUNT(*), 
        4
    ) AS churn_rate_decimal,
    ROUND(
        SUM(CASE WHEN churn_label = 'Yes' THEN 100.0 ELSE 0.0 END) / COUNT(*), 
        2
    ) || '%' AS churn_rate_percentage
FROM telco_churn_data;

SELECT table_schema, table_name 
FROM information_schema.tables 
WHERE table_name LIKE '%churn%';