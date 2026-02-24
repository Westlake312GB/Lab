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

-- List categories with their subcategories; keep parents even if no child exists
SELECT 
    parent.cat_id AS parent_id,
    parent.cat_name AS parent_name,
    child.cat_id AS child_id,
    child.cat_name AS child_name
FROM 
    categories parent
LEFT JOIN categories child 
    ON parent.cat_id = child.cat_parentid
ORDER BY 
    parent.cat_id, child.cat_id;

-- List products where the number of reviews is greater than 10
SELECT 
    p.prod_id AS "Product ID",
    p.prod_name AS "Product Name"
FROM 
    products p
WHERE 
    (SELECT COUNT(*) FROM reviews r WHERE r.prod_id = p.prod_id) > 10
ORDER BY 
    p.prod_id;

-- Find users who are in the set of active sessions
SELECT 
    u.user_id,
    u.user_username
FROM 
    users u
WHERE 
    u.user_id IN (SELECT DISTINCT user_id FROM sessions)
ORDER BY 
    u.user_id;

-- List products whose category is itself a child of another category
SELECT 
    p.prod_id,
    p.prod_name,
    c.cat_name
FROM 
    products p
INNER JOIN categories c 
    ON p.cat_id = c.cat_id
WHERE 
    p.cat_id IN (
        SELECT cat_id 
        FROM categories 
        WHERE cat_parentid IN (
            SELECT cat_id FROM categories
        )
    )
ORDER BY 
    p.prod_id;

-- List active accounts joined to active users, using a subquery instead of the full users table
SELECT 
    a.acc_id,
    active_users.user_id,
    active_users.user_username,
    a.acc_startdate,
    a.acc_isactive
FROM 
    accounts a
INNER JOIN (
    SELECT user_id, user_username 
    FROM users 
    WHERE user_isactive = 'Y'
) active_users
    ON a.user_id = active_users.user_id
WHERE 
    a.acc_isactive = 'Y'
ORDER BY 
    a.acc_id;

-- Show total inventory quantity grouped by brand name using inventories -> products -> brands
SELECT 
    b.brand_name,
    SUM(i.inv_stockquantity) AS total_inventory
FROM 
    inventories i
INNER JOIN products p 
    ON i.prod_id = p.prod_id
INNER JOIN brands b 
    ON p.brand_id = b.brand_id
GROUP BY 
    b.brand_name
ORDER BY 
    total_inventory DESC;

-- Find users with more than 5 sessions using users and sessions tables
SELECT 
    u.user_id,
    u.user_username,
    COUNT(s.ses_token) AS session_count
FROM 
    users u
INNER JOIN sessions s 
    ON u.user_id = s.user_id
GROUP BY 
    u.user_id, u.user_username
HAVING 
    COUNT(s.ses_token) > 5
ORDER BY 
    session_count DESC;
