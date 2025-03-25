
# DATA TABLES
## 4.1.Listar todos los usuarios activos con nombre, email, país y total pagado en subscripciones desde 2024 hasta hoy en colones
SELECT \
    u.name AS 'Nombre Completo',\
    c.value AS 'Email',\
    co.name AS 'País',\
    SUM(\
        CASE \
            WHEN co.currencyId = 3 THEN p.actualmamount -- Ya está en colones\
            ELSE p.actualmamount * 550 -- Convertir a colones (tipo de cambio fijo de 550)\
        END\
    ) AS 'Total Pagado en Colones'\
FROM \
    users u\
    JOIN contactinfoperperson c ON u.userid = c.userid AND c.contactinfotypeid = 1 -- Email\
    JOIN country co ON u.countryid = co.countryid\
    JOIN userssubscriptions us ON u.userid = us.userid\
    JOIN payments p ON us.usersubsid = p.usersubsid\
WHERE \
    u.isactive = 1\
    AND p.date >= '2024-01-01'\
    AND p.date <= NOW()\
GROUP BY\ 
    u.userid, u.name, c.value, co.name\
HAVING \
    COUNT(p.paymentsid) > 0\
ORDER BY \
    'Total Pagado en Colones' DESC;
| Nombre            | Email                          | País          | Pagado en colones |
|-------------------|--------------------------------|---------------|---------------|
| María González 01 | maría.gonzález1@ejemplo.com    | Costa Rica    | 64113         |
| Juan Pérez 02     | juan.pérez2@ejemplo.com        | México        | 11000         |
| Carlos Rodríguez 03 | carlos.rodríguez3@ejemplo.com  | Costa Rica    | 64276         |
| María González 04 | maría.gonzález4@ejemplo.com    | Costa Rica    | 74876         |
| Pedro López 05    | pedro.lópez5@ejemplo.com       | Estados Unidos | 11000        |
| María González 06 | maría.gonzález6@ejemplo.com    | México        | 109450        |
| Juan Pérez 07     | juan.pérez7@ejemplo.com        | Costa Rica    | 107690        |
| María González 08 | maría.gonzález8@ejemplo.com    | Estados Unidos | 82500        |
| Ana Martínez 09   | ana.martínez9@ejemplo.com      | México        | 53350         |
| Carlos Rodríguez 10 | carlos.rodríguez10@ejemplo.com | Costa Rica    | 162940        |
| María González 11 | maría.gonzález11@ejemplo.com   | Estados Unidos | 158950       |
| Juan Pérez 12     | juan.pérez12@ejemplo.com       | Costa Rica    | 53079         |
| María González 13 | maría.gonzález13@ejemplo.com   | Unión Europea | 105050        |
| Pedro López 15    | pedro.lópez15@ejemplo.com      | Costa Rica    | 106263        |
| Pedro López 16    | pedro.lópez16@ejemplo.com      | Costa Rica    | 164553        |
| Juan Pérez 17     | juan.pérez17@ejemplo.com       | Estados Unidos | 161150       |
| Carlos Rodríguez 18 | carlos.rodríguez18@ejemplo.com | Reino Unido   | 85800         |
| Ana Martínez 19   | ana.martínez19@ejemplo.com     | Costa Rica    | 54384         |
| María González 20 | maría.gonzález20@ejemplo.com   | Costa Rica    | 193547        |
| Ana Martínez 21   | ana.martínez21@ejemplo.com     | Reino Unido   | 54450         |
| Carlos Rodríguez 22 | carlos.rodríguez22@ejemplo.com | Estados Unidos | 106700       |
| María González 23 | maría.gonzález23@ejemplo.com   | Unión Europea | 55000         |
| Ana Martínez 24   | ana.martínez24@ejemplo.com     | Unión Europea | 53350         |
| Pedro López 25    | pedro.lópez25@ejemplo.com      | Costa Rica    | 109996        |
| Juan Pérez 26     | juan.pérez26@ejemplo.com       | Costa Rica    | 191215        |
| María González 27 | maría.gonzález27@ejemplo.com   | Unión Europea | 161150        |
| Juan Pérez 28     | juan.pérez28@ejemplo.com       | Costa Rica    | 107027        |
| Pedro López 29    | pedro.lópez29@ejemplo.com      | Costa Rica    | 52958         |
| Carlos Rodríguez 30 | carlos.rodríguez30@ejemplo.com | Costa Rica    | 106502        |
| María González 32 | maría.gonzález32@ejemplo.com   | Costa Rica    | 163185        |
| María González 33 | maría.gonzález33@ejemplo.com   | Costa Rica    | 15812         |
| María González 34 | maría.gonzález34@ejemplo.com   | Costa Rica    | 108275        |
| Pedro López 35    | pedro.lópez35@ejemplo.com      | Costa Rica    | 63767         |

## 4.2.Listar personas con nombre, email que les queden menos de 15 días para pagar una nueva subscripción
SELECT \
    u.name AS 'Nombre Completo',\
    c.value AS 'Email',\
    us.end_date AS 'Fecha Fin Subscripción',\
    DATEDIFF(us.end_date, NOW()) AS 'Días Restantes'\
FROM \
    users u\
    JOIN contactinfoperperson c ON u.userid = c.userid AND c.contactinfotypeid = 1 -- Email\
    JOIN userssubscriptions us ON u.userid = us.userid\
WHERE \
    u.isactive = 1\
    AND us.end_date > NOW() -- Aún no ha vencido\
    AND DATEDIFF(us.end_date, NOW()) < 15 -- Menos de 15 días\
ORDER BY \
    DATEDIFF(us.end_date, NOW()) ASC;
| Nombre           | Email                       | Fecha Fin de subscripcion   | Dias Restantes |
|:-----------------|:---------------------------:|:--------------------:|-------:|
| Ana Martínez 09  | ana.martínez9@ejemplo.com   | 2025-03-26 01:48:51  | 1      |
| María González 06 | maría.gonzález6@ejemplo.com | 2025-04-02 01:48:51  | 8      |
| Ana Martínez 24  | ana.martínez24@ejemplo.com  | 2025-04-04 01:48:51  | 10     |
| María González 20 | maría.gonzález20@ejemplo.com | 2025-04-05 01:48:51 | 11     |
| María González 08 | maría.gonzález8@ejemplo.com | 2025-04-07 01:48:51 | 13     |
| Juan Pérez 26    | juan.pérez26@ejemplo.com    | 2025-04-07 01:48:51 | 13     |

## 4.3.un ranking del top 15 de usuarios que más uso le dan a la aplicación y el top 15 que menos uso le dan a la aplicación (15 y 15 registros)
### Mejores 15
SELECT \
    u.userid,\
    u.name AS Nombre,\
    COUNT(a.usageid) AS Sesiones,\
    ROUND(SUM(a.sessionduration)/3600, 2) AS Horas_Uso,\
    AVG(a.actionsperformed) AS Acciones_Por_Uso\
FROM \
    users u\
JOIN \
    appusage a ON u.userid = a.userid\
GROUP BY\ 
    u.userid, u.name\
ORDER BY \
    Sesiones DESC, Horas_Uso DESC\
LIMIT 15;

| ID  | Nombre            | Sesiones | Horas de uso   | Acciones promedio por uso   |
|----|-------------------|--------|---------|----------|
| 9  | Ana Martínez 09   | 74     | 79.86   | 42.2568  |
| 1  | María González 01 | 69     | 84.07   | 44.9855  |
| 3  | Carlos Rodríguez 03 | 67    | 72.34   | 49.7164  |
| 7  | Juan Pérez 07     | 66     | 63.08   | 49.8182  |
| 8  | María González 08 | 63     | 77.23   | 56.0635  |
| 15 | Pedro López 15    | 61     | 67.03   | 53.2131  |
| 2  | Juan Pérez 02     | 50     | 56.23   | 57.1000  |
| 13 | María González 13 | 47     | 56.14   | 45.8723  |
| 6  | María González 06 | 41     | 37.49   | 49.3902  |
| 12 | Juan Pérez 12     | 36     | 36.15   | 46.0556  |
| 10 | Carlos Rodríguez 10 | 35    | 39.35   | 60.0857  |
| 5  | Pedro López 05    | 33     | 35.72   | 58.0000  |
| 4  | María González 04 | 32     | 33.42   | 54.4063  |
| 11 | María González 11 | 32     | 30.86   | 46.3125  |
| 16 | Pedro López 16    | 27     | 27.99   | 54.8519  |

### Peores 15 
SELECT \
    u.userid,\
    u.name AS Nombre,\
    COUNT(a.usageid) AS Sesiones,\
    ROUND(SUM(a.sessionduration)/3600, 2) AS Horas_Uso,\
    AVG(a.actionsperformed) AS Acciones_Por_Uso\
FROM \
    users u\
JOIN \
    appusage a ON u.userid = a.userid\
WHERE\
    u.isactive = 1\
GROUP BY 
    u.userid, u.name\
ORDER BY \
    Sesiones ASC, Horas_Uso ASC
| ID  | Nombre            | Sesiones | Horas de uso   | Acciones promedio por uso    |
|---:|:------------------|-------:|------:|----------:|
| 43 | Ana Martínez 43   | 1      | 0.09  | 99.0000   |
| 48 | Juan Pérez 48     | 2      | 1.03  | 22.5000   |
| 50 | María González 50 | 2      | 2.15  | 49.0000   |
| 38 | María González 38 | 2      | 2.28  | 51.0000   |
| 39 | Juan Pérez 39     | 2      | 2.56  | 52.5000   |
| 44 | Ana Martínez 44   | 2      | 2.82  | 13.5000   |
| 42 | Juan Pérez 42     | 3      | 2.51  | 38.6667   |
| 36 | Ana Martínez 36   | 3      | 2.88  | 35.0000   |
| 37 | Carlos Rodríguez 37 | 3    | 4.07  | 44.3333   |
| 46 | María González 46 | 4      | 2.41  | 42.0000   |
| 47 | Carlos Rodríguez 47 | 5    | 4.96  | 76.0000   |
| 40 | Carlos Rodríguez 40 | 5    | 5.24  | 46.2000   |
| 41 | Juan Pérez 41     | 5      | 8.05  | 43.2000   |
| 34 | Juan Pérez 34     | 7      | 9.88  | 26.2857   |
| 19 | Carlos Rodríguez 19 | 8    | 7.49  | 43.5000   |

## 4.4 Top de los errores de la AI
SELECT \
    ae.errorclassid,\
    ae.categoryname,\
    ae.description AS error_category_description,\
    COUNT(te.iderrors) AS error_count\
FROM \
    aierrorclass ae\
JOIN \
    transcriptionerrors te ON ae.errorclassid = te.errorclassid\
WHERE \
    te.trytime >='2024-01-01 00:00:00'\
GROUP BY \
    ae.errorclassid, ae.categoryname, ae.description\
ORDER BY \
    error_count DESC;
