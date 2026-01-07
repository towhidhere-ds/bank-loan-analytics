-- KPI: total number of loan applications
SELECT 
    COUNT(id) AS total_applications 
FROM bank_loan_data;


-- KPI: month-to-date (MTD) loan applications (December)
SELECT 
    COUNT(id) AS total_applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;


-- KPI: previous month-to-date (PMTD) loan applications (November)
SELECT 
    COUNT(id) AS total_applications 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11;


-- KPI: total funded loan amount
SELECT 
    SUM(loan_amount) AS total_funded_amount 
FROM bank_loan_data;


-- KPI: MTD total funded amount (December)
SELECT 
    SUM(loan_amount) AS total_funded_amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;


-- KPI: PMTD total funded amount (November)
SELECT 
    SUM(loan_amount) AS total_funded_amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11;


-- KPI: total amount received from all loans
SELECT 
    SUM(total_payment) AS total_amount_collected 
FROM bank_loan_data;


-- KPI: MTD total amount received (December)
SELECT 
    SUM(total_payment) AS total_amount_collected 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;


-- KPI: PMTD total amount received (November)
SELECT 
    SUM(total_payment) AS total_amount_collected 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11;


-- KPI: Average interest rate across all loans
SELECT 
    AVG(int_rate) * 100 AS avg_int_rate 
FROM bank_loan_data;


-- KPI: MTD average interest rate (December)
SELECT 
    AVG(int_rate) * 100 AS mtd_avg_int_rate 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;


-- KPI: PMTD average interest rate (November)
SELECT 
    AVG(int_rate) * 100 AS pmtd_avg_int_rate 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11;


-- KPI: Average debt-to-income (DTI) ratio
SELECT 
    AVG(dti) * 100 AS avg_dti 
FROM bank_loan_data;


-- KPI: MTD average DTI (December)
SELECT 
    AVG(dti) * 100 AS mtd_avg_dti 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12;


-- KPI: PMTD average DTI (November)
SELECT 
    AVG(dti) * 100 AS pmtd_avg_dti 
FROM bank_loan_data
WHERE MONTH(issue_date) = 11;

-- __good loans issued analysis__

-- calculating percentage of good loans (fully paid or current)
SELECT
    (COUNT(CASE 
        WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' 
        THEN id END) * 100.0) / COUNT(id) AS good_loan_percentage
FROM bank_loan_data;


-- counting total number of good loan applications
SELECT 
    COUNT(id) AS good_loan_applications 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' 
   OR loan_status = 'Current';


-- calculating total funded amount for good loans
SELECT 
    SUM(loan_amount) AS good_loan_funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' 
   OR loan_status = 'Current';


-- calculating total amount received from good loans
SELECT 
    SUM(total_payment) AS good_loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Fully Paid' 
   OR loan_status = 'Current';


-- __bad loan issued analysis__

-- calculating percentage of bad loans (charged off)
SELECT
    (COUNT(CASE 
        WHEN loan_status = 'Charged Off' 
        THEN id END) * 100.0) / COUNT(id) AS bad_loan_percentage
FROM bank_loan_data;


-- counting total number of bad loan applications
SELECT 
    COUNT(id) AS bad_loan_applications 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- calculating total funded amount for bad loans
SELECT 
    SUM(loan_amount) AS bad_loan_funded_amount 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- calculating total amount received from bad loans
SELECT 
    SUM(total_payment) AS bad_loan_amount_received 
FROM bank_loan_data
WHERE loan_status = 'Charged Off';



-- __loan status analysis__


-- analyzing loan performance by loan status
SELECT
    loan_status,
    COUNT(id) AS loan_count,
    SUM(total_payment) AS total_amount_received,
    SUM(loan_amount) AS total_funded_amount,
    AVG(int_rate * 100) AS interest_rate,
    AVG(dti * 100) AS dti
FROM bank_loan_data
GROUP BY loan_status;


-- MTD funded and received amounts by loan status (December)
SELECT 
    loan_status, 
    SUM(total_payment) AS mtd_total_amount_received, 
    SUM(loan_amount) AS mtd_total_funded_amount 
FROM bank_loan_data
WHERE MONTH(issue_date) = 12 
GROUP BY loan_status;



-- __bank loan report | overview


-- monthly loan trend analysis
SELECT 
    MONTH(issue_date) AS month_number, 
    DATENAME(MONTH, issue_date) AS month_name, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date);


-- loan distribution by state
SELECT 
    address_state AS state, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;


-- loan analysis by loan term
SELECT 
    term AS term, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY term
ORDER BY term;


-- loan analysis by employee length
SELECT 
    emp_length AS employee_length, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;


-- loan analysis by loan purpose
SELECT 
    purpose AS purpose, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;


-- loan analysis by home ownership
SELECT 
    home_ownership AS home_ownership, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;


-- __filtered analysis example


-- analyzing loan purpose for grade A loans only
-- this logic matches dashboard filters for validation
SELECT 
    purpose AS purpose, 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;
