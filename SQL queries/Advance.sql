-- Show all users with their sessions, including users without sessions
SELECT 
    u.user_id,
    u.user_username,
    s.ses_token,
    s.ses_createdat
FROM 
    users u
LEFT JOIN sessions s 
    ON u.user_id = s.user_id
ORDER BY 
    u.user_id;

-- Show all users with their sessions, using NVL to show 'N/A' for missing tokens
SELECT 
    u.user_id,
    u.user_username,
    NVL(s.ses_token, 'N/A') AS ses_token,
    s.ses_createdat
FROM 
    users u
LEFT JOIN sessions s 
    ON u.user_id = s.user_id
ORDER BY 
    u.user_id;

-- Show all users with their sessions, using COALESCE to show 'N/A' for missing tokens
SELECT 
    u.user_id,
    u.user_username,
    COALESCE(s.ses_token, 'N/A') AS ses_token,
    s.ses_createdat
FROM 
    users u
LEFT JOIN sessions s 
    ON u.user_id = s.user_id
ORDER BY 
    u.user_id;

-- List all users and their accounts, including users without accounts
SELECT 
    u.user_id,
    u.user_username,
    a.acc_id,
    a.acc_startdate,
    a.acc_isactive
FROM 
    users u
RIGHT JOIN accounts a 
    ON u.user_id = a.user_id
ORDER BY 
    u.user_id;

-- List accounts with their type and addresses, keeping accounts even if no address exists
SELECT 
    a.acc_id,
    at.type_name,
    ad.add_street,
    ad.add_city
FROM 
    accounts a
INNER JOIN account_type at 
    ON a.type_id = at.type_id
LEFT JOIN addresses ad 
    ON a.acc_id = ad.acc_id
ORDER BY 
    a.acc_id;
