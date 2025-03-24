-- 4.1 Listar todos los usuarios activos con nombre, email, país y total pagado en subscripciones desde 2024 hasta hoy en colones
SELECT 
    u.name AS 'Nombre Completo',
    c.value AS 'Email',
    co.name AS 'País',
    SUM(
        CASE 
            WHEN p.currencyId = 3 THEN p.actualmamount -- Ya está en colones
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