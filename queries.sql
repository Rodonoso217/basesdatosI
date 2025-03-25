-- 4.1 Listar todos los usuarios activos con nombre, email, país y total pagado en subscripciones desde 2024 hasta hoy en colones
SELECT 
    u.name AS 'Nombre Completo',
    c.value AS 'Email',
    co.name AS 'País',
    SUM(
        CASE 
            WHEN co.currencyId = 3 THEN p.actualmamount -- Ya está en colones
            ELSE p.actualmamount * 550 -- Convertir a colones (tipo de cambio fijo de 550)
        END
    ) AS 'Total Pagado en Colones'
FROM 
    users u
    JOIN contactinfoperperson c ON u.userid = c.userid AND c.contactinfotypeid = 1 -- Email
    JOIN country co ON u.countryid = co.countryid
    JOIN userssubscriptions us ON u.userid = us.userid
    JOIN payments p ON us.usersubsid = p.usersubsid
WHERE 
    u.isactive = 1
    AND p.date >= '2024-01-01'
    AND p.date <= NOW()
GROUP BY 
    u.userid, u.name, c.value, co.name
HAVING 
    COUNT(p.paymentsid) > 0
ORDER BY 
    'Total Pagado en Colones' DESC;

-- 4.2 Listar personas con nombre, email que les queden menos de 15 días para pagar una nueva subscripción
SELECT 
    u.name AS 'Nombre Completo',
    c.value AS 'Email',
    us.end_date AS 'Fecha Fin Subscripción',
    DATEDIFF(us.end_date, NOW()) AS 'Días Restantes'
FROM 
    users u
    JOIN contactinfoperperson c ON u.userid = c.userid AND c.contactinfotypeid = 1 -- Email
    JOIN userssubscriptions us ON u.userid = us.userid
WHERE 
    u.isactive = 1
    AND us.end_date > NOW() -- Aún no ha vencido
    AND DATEDIFF(us.end_date, NOW()) < 15 -- Menos de 15 días
ORDER BY 
    DATEDIFF(us.end_date, NOW()) ASC;
    
-- 4.3 un ranking del top 15 de usuarios que más uso le dan a la aplicación y el top 15 que menos uso le dan a la aplicación (15 y 15 registros)
-- Top 15 usuarios con más sesiones
SELECT 
    u.userid,
    u.name AS Nombre,
    COUNT(a.usageid) AS Sesiones,
    ROUND(SUM(a.sessionduration)/3600, 2) AS Horas_Uso,
    AVG(a.actionsperformed) AS Acciones_Por_Uso
FROM 
    users u
JOIN 
    appusage a ON u.userid = a.userid
GROUP BY 
    u.userid, u.name
ORDER BY 
    Sesiones DESC, Horas_Uso DESC
LIMIT 15;

-- Top 15 usuarios con menos sesiones
SELECT 
    ROW_NUMBER() OVER () AS Top,
    u.userid,
    u.name AS Nombre,
    COUNT(a.usageid) AS Sesiones,
    ROUND(SUM(a.sessionduration)/3600, 2) AS Horas_Uso,
    AVG(a.actionsperformed) AS Acciones_Por_Uso
FROM 
    users u
JOIN 
    appusage a ON u.userid = a.userid
WHERE
    u.isactive = 1
GROUP BY 
    u.userid, u.name
ORDER BY 
    Sesiones ASC, Horas_Uso ASC
LIMIT 15;
-- 4.4 Top de los errores de la AI
SELECT 
    ae.errorclassid,
    ae.categoryname,
    ae.description AS error_category_description,
    COUNT(te.iderrors) AS error_count
FROM 
    aierrorclass ae
JOIN 
    transcriptionerrors te ON ae.errorclassid = te.errorclassid
WHERE 
    te.trytime >='2024-01-01 00:00:00'
GROUP BY 
    ae.errorclassid, ae.categoryname, ae.description
ORDER BY 
    error_count DESC;alter
    
    
    -- ver tablas
SELECT 
    'currencies' AS table_name, 
    COUNT(*) AS count 
FROM currencies
UNION ALL
SELECT 'country', COUNT(*) FROM country
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'paymentmethods', COUNT(*) FROM paymentmethods
UNION ALL
SELECT 'userpaymentmethods', COUNT(*) FROM userpaymentmethods
UNION ALL
SELECT 'plans', COUNT(*) FROM plans
UNION ALL
SELECT 'planpricing', COUNT(*) FROM planpricing
UNION ALL
SELECT 'userssubscriptions', COUNT(*) FROM userssubscriptions
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'exchangeRate', COUNT(*) FROM exchangeRate
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'appusage', COUNT(*) FROM appusage
UNION ALL
SELECT 'contactinfotype', COUNT(*) FROM contactinfotype
UNION ALL
SELECT 'contactinfoperperson', COUNT(*) FROM contactinfoperperson
UNION ALL
SELECT 'aierrorclass', COUNT(*) FROM aierrorclass
UNION ALL
SELECT 'transcriptionerrors', COUNT(*) FROM transcriptionerrors
UNION ALL
SELECT 'transcription', COUNT(*) FROM transcription
UNION ALL
SELECT 'conversationinteractions', COUNT(*) FROM conversationinteractions
UNION ALL
SELECT 'conversations', COUNT(*) FROM conversations
UNION ALL
SELECT 'logs', COUNT(*) FROM logs
UNION ALL
SELECT 'files', COUNT(*) FROM files;
-- calls
CALL PopulatePaymentAssistantDB();
CALL PopulateUsageData();
CALL PopulateConversationData()
