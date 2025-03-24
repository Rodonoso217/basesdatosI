DELIMITER //

CREATE PROCEDURE PopulatePaymentAssistantDB()
BEGIN
    -- Variables para controlar la cantidad de registros
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE k INT DEFAULT 0;
    DECLARE total_users INT DEFAULT 50;
    DECLARE random_number INT;
    DECLARE random_date DATETIME;
    DECLARE random_email VARCHAR(100);
    DECLARE random_name VARCHAR(100);
    DECLARE subscription_start_date DATETIME;
    DECLARE subscription_end_date DATETIME;
    DECLARE days_difference INT;
    DECLARE subscription_amount DECIMAL(10,2);
    DECLARE usage_count INT;
    DECLARE error_count INT;
    
    -- Limpiar datos existentes para evitar duplicados
    SET FOREIGN_KEY_CHECKS = 0;
    
    TRUNCATE TABLE currencies;
    TRUNCATE TABLE country;
    TRUNCATE TABLE users;
    TRUNCATE TABLE paymentmethods;
    TRUNCATE TABLE userpaymentmethods;
    TRUNCATE TABLE plans;
    TRUNCATE TABLE planpricing;
    TRUNCATE TABLE userssubscriptions;
    TRUNCATE TABLE payments;
    TRUNCATE TABLE exchangeRate;
    TRUNCATE TABLE transactions;
    TRUNCATE TABLE appusage;
    TRUNCATE TABLE contactinfotype;
    TRUNCATE TABLE contactinfoperperson;
    TRUNCATE TABLE aierrorclass;
    TRUNCATE TABLE transcriptionerrors;
    TRUNCATE TABLE transcription;
    TRUNCATE TABLE conversationinteractions;
    TRUNCATE TABLE conversations;
    TRUNCATE TABLE logs;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
    -- 1. Insertar monedas
    INSERT INTO currencies (name, acronym, countryid, symbol) VALUES 
    ('Dólar estadounidense', 'USD', 1, '$'),
    ('Euro', 'EUR', 2, '€'),
    ('Colón costarricense', 'CRC', 3, '₡'),
    ('Peso mexicano', 'MXN', 4, '$'),
    ('Libra esterlina', 'GBP', 5, '£');
    
    -- 2. Insertar países
    INSERT INTO country (name, currencyId) VALUES 
    ('Estados Unidos', 1),
    ('Unión Europea', 2),
    ('Costa Rica', 3),
    ('México', 4),
    ('Reino Unido', 5);
    
    -- 3. Insertar tipos de contacto
    INSERT INTO contactinfotype (name) VALUES
    ('Email'),
    ('Teléfono'),
    ('Dirección');
    
    -- 4. Insertar métodos de pago
    INSERT INTO paymentmethods (name, APIurl, securityKey, `key`, enabled) VALUES
    ('Tarjeta de crédito', 'https://api.creditcard.com', UNHEX(MD5('secretCC')), UNHEX(MD5('keyCC')), 1),
    ('PayPal', 'https://api.paypal.com', UNHEX(MD5('secretPP')), UNHEX(MD5('keyPP')), 1),
    ('Transferencia bancaria', 'https://api.bankwire.com', UNHEX(MD5('secretBW')), UNHEX(MD5('keyBW')), 1);
    
    -- 5. Insertar planes
    INSERT INTO plans (name, description, isactive, createdat, updatedat) VALUES
    ('Básico', 'Plan básico con funcionalidades limitadas', 1, NOW(), NOW()),
    ('Estándar', 'Plan estándar con la mayoría de funcionalidades', 1, NOW(), NOW()),
    ('Premium', 'Plan premium con todas las funcionalidades', 1, NOW(), NOW());
    
    -- 6. Insertar precios de planes
    INSERT INTO planpricing (billingperiod, price, createdat, updatedat, plansid, currencyId) VALUES
    ('Mensual', 9.99, NOW(), NOW(), 1, 1),
    ('Anual', 99.99, NOW(), NOW(), 1, 1),
    ('Mensual', 19.99, NOW(), NOW(), 2, 1),
    ('Anual', 199.99, NOW(), NOW(), 2, 1),
    ('Mensual', 29.99, NOW(), NOW(), 3, 1),
    ('Anual', 299.99, NOW(), NOW(), 3, 1),
    ('Mensual', 5500, NOW(), NOW(), 1, 3),
    ('Anual', 55000, NOW(), NOW(), 1, 3),
    ('Mensual', 11000, NOW(), NOW(), 2, 3),
    ('Anual', 110000, NOW(), NOW(), 2, 3),
    ('Mensual', 16500, NOW(), NOW(), 3, 3),
    ('Anual', 165000, NOW(), NOW(), 3, 3);
    
    -- 7. Insertar tipos de errores de IA
    INSERT INTO aierrorclass (categoryname, description) VALUES
    ('Reconocimiento de entidades', 'Error al identificar entidades de pago'),
    ('Clasificación de intenciones', 'Error al clasificar la intención del usuario'),
    ('Análisis de sentimiento', 'Error al analizar el sentimiento del usuario'),
    ('Interpretación de montos', 'Error al interpretar montos monetarios'),
    ('Halucinación', 'Generación de información falsa no presente en los datos'),
    ('Contexto conversacional', 'Fallas manteniendo el contexto de la conversación'),
    ('Fechas y períodos', 'Errores interpretando fechas o períodos de pago');
    
    -- 8. Insertar tasa de cambio (USD a CRC)
    INSERT INTO exchangeRate (sourcecurrencyid, targetcurrencyid, startdate, enddate, exchangerate, enabled, currentExchangeRate) VALUES
    (1, 3, '2023-01-01', NULL, 550.0, 1, 1),  -- 1 USD = 550 CRC
    (3, 1, '2023-01-01', NULL, 0.00181818, 1, 1); -- 1 CRC = 0.00181818 USD
    
    -- 9. Generar usuarios
    SET i = 1;
    WHILE i <= total_users DO
        -- Nombre aleatorio
        SET random_number = FLOOR(1 + RAND() * 5);
        CASE random_number
            WHEN 1 THEN SET random_name = CONCAT('Juan ', 'Pérez ', LPAD(i, 2, '0'));
            WHEN 2 THEN SET random_name = CONCAT('María ', 'González ', LPAD(i, 2, '0'));
            WHEN 3 THEN SET random_name = CONCAT('Carlos ', 'Rodríguez ', LPAD(i, 2, '0'));
            WHEN 4 THEN SET random_name = CONCAT('Ana ', 'Martínez ', LPAD(i, 2, '0'));
            ELSE SET random_name = CONCAT('Pedro ', 'López ', LPAD(i, 2, '0'));
        END CASE;
        
        -- Email aleatorio
        SET random_email = CONCAT(LOWER(SUBSTRING_INDEX(random_name, ' ', 1)), '.', 
                                 LOWER(SUBSTRING_INDEX(SUBSTRING_INDEX(random_name, ' ', 2), ' ', -1)), 
                                 i, '@ejemplo.com');
        
        -- País aleatorio (con más probabilidad para Costa Rica)
        SET random_number = FLOOR(1 + RAND() * 10);
        IF random_number > 6 THEN
            SET random_number = 3; -- Costa Rica
        ELSE
            SET random_number = FLOOR(1 + RAND() * 5);
        END IF;
        
        -- Insertar usuario
        INSERT INTO users (name, fecha_registro, password, usertype, isactive, countryid)
        VALUES (
            random_name, 
            DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 730) DAY), 
            UNHEX(MD5(CONCAT('password', i))), 
            CASE FLOOR(1 + RAND() * 3) 
                WHEN 1 THEN 'regular' 
                WHEN 2 THEN 'premium' 
                ELSE 'admin' 
            END,
            CASE WHEN RAND() > 0.1 THEN 1 ELSE 0 END, -- 90% activos, 10% inactivos
            random_number
        );
        
        -- Insertar información de contacto (email)
        INSERT INTO contactinfoperperson (userid, contactinfotypeid, value, enabled, lastupdate)
        VALUES (
            i, 
            1, -- Email 
            random_email,
            1,
            NOW()
        );
        
        -- Método de pago para usuario
        INSERT INTO userpaymentmethods (userid, paymentmethodid, accountinfo, accountnumber, expirationdate, isdefault, enabled)
        VALUES (
            i,
            FLOOR(1 + RAND() * 3),
            CONCAT('Info de cuenta ', i),
            CONCAT('45678901234', LPAD(i, 4, '0')),
            DATE_ADD(NOW(), INTERVAL FLOOR(1 + RAND() * 24) MONTH),
            1,
            1
        );
        
        SET i = i + 1;
    END WHILE;
    
    -- 10. Generar subscripciones de usuario (asegurando que haya suficientes próximas a vencer)
    SET i = 1;
    WHILE i <= total_users DO
        -- Solo crear suscripciones para usuarios activos
        SELECT isactive INTO @is_active FROM users WHERE userid = i;
        
        IF @is_active = 1 THEN
            -- Determinar fecha de inicio y fin de suscripción
            SET random_number = FLOOR(1 + RAND() * 100);
            
            -- 30% de usuarios con suscripción próxima a vencer (menos de 15 días)
            IF random_number <= 30 THEN
                SET subscription_start_date = DATE_SUB(NOW(), INTERVAL FLOOR(11 + RAND() * 6) MONTH);
                SET subscription_end_date = DATE_ADD(NOW(), INTERVAL FLOOR(1 + RAND() * 14) DAY);
            ELSE
                SET subscription_start_date = DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 11) MONTH);
                SET subscription_end_date = DATE_ADD(subscription_start_date, INTERVAL 12 MONTH);
            END IF;
            
            -- Insertar suscripción
            INSERT INTO userssubscriptions (
                userid, 
                start_date, 
                end_date, 
                autorenew, 
                status, 
                createdat, 
                updateat, 
                plansid, 
                priceid
            )
            VALUES (
                i,
                subscription_start_date,
                subscription_end_date,
                CASE WHEN RAND() > 0.2 THEN 1 ELSE 0 END, -- 80% autorenew
                'active',
                subscription_start_date,
                subscription_start_date,
                FLOOR(1 + RAND() * 3), -- Plan aleatorio
                CASE 
                    WHEN (SELECT countryid FROM users WHERE userid = i) = 3 THEN FLOOR(7 + RAND() * 6) -- Precios en colones para Costa Rica
                    ELSE FLOOR(1 + RAND() * 6) -- Precios en dólares para otros países
                END
            );
            
            -- Guardar el ID de la suscripción
            SET @subscription_id = LAST_INSERT_ID();
            
            -- 11. Generar pagos históricos para esta suscripción
            SELECT DATEDIFF(NOW(), start_date) INTO days_difference 
            FROM userssubscriptions 
            WHERE usersubsid = @subscription_id;
            
            -- Calcular cuántos pagos mensuales deberían haberse realizado
            SET j = 0;
            WHILE j * 30 < days_difference DO
                -- Fecha de pago
                SET random_date = DATE_ADD(subscription_start_date, INTERVAL j MONTH);
                
                -- Seleccionar precio según plan y país
                SELECT p.price, p.currencyId 
                INTO @payment_amount, @currency_id
                FROM userssubscriptions us
                JOIN planpricing p ON us.priceid = p.priceid
                WHERE us.usersubsid = @subscription_id;
                
                -- Si es pago anual, solo se hace un pago, si es mensual, se hacen pagos mensuales
                SELECT billingperiod INTO @billing_period 
                FROM planpricing 
                WHERE priceid = (
                    SELECT priceid FROM userssubscriptions WHERE usersubsid = @subscription_id
                );
                
                IF @billing_period = 'Anual' AND j > 0 THEN
                    -- Ya se hizo el pago anual, salir del bucle
                    SET j = days_difference; -- Para salir del bucle
                ELSE
                    -- Insertar pago
                    INSERT INTO payments (
                        amount, 
                        actualmamount, 
                        description, 
                        error, 
                        date, 
                        checksum, 
                        currencyId, 
                        userpaymentmethodid, 
                        usersubsid
                    )
                    VALUES (
                        @payment_amount,
                        @payment_amount * (1 - (RAND() * 0.05)), -- Pequeña variación
                        CONCAT('Pago de suscripción ', j+1),
                        NULL,
                        random_date,
                        UNHEX(MD5(CONCAT('checksum', i, j))),
                        @currency_id,
                        (SELECT userpaymentmethodid FROM userpaymentmethods WHERE userid = i LIMIT 1),
                        @subscription_id
                    );
                    
                    -- Registrar también la transacción
                    INSERT INTO transactions (
                        transaction_date,
                        transaction_amount,
                        transaction_state,
                        error_description,
                        paymentsid,
                        description,
                        referenceNumber,
                        checksum,
                        exchangeRateId,
                        currencyId
                    )
                    VALUES (
                        random_date,
                        @payment_amount,
                        'successful',
                        '',
                        LAST_INSERT_ID(),
                        CONCAT('Transacción ', j+1, ' para suscripción'),
                        CONCAT('REF-', LPAD(i, 4, '0'), '-', LPAD(j, 2, '0')),
                        UNHEX(MD5(CONCAT('checksum-trans', i, j))),
                        CASE WHEN @currency_id = 3 THEN 2 ELSE 1 END, -- Tasa de cambio según moneda
                        @currency_id
                    );
                END IF;
                
                SET j = j + 1;
            END WHILE;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    -- 12. Generar registros de uso de la aplicación
    -- Crearemos múltiples registros para cada usuario con diferentes patrones
    SET i = 1;
    WHILE i <= total_users DO
        -- Solo crear registros para usuarios activos
        SELECT isactive INTO @is_active FROM users WHERE userid = i;
        
        IF @is_active = 1 THEN
            -- Crear entre 5 y 30 registros de uso por usuario
            SET usage_count = FLOOR(5 + RAND() * 25);
            
            -- Crear más registros para los primeros 15 usuarios (top usuarios)
            IF i <= 15 THEN
                SET usage_count = FLOOR(30 + RAND() * 50); -- Usuarios intensivos
            END IF;
            
            -- Crear menos registros para los últimos 15 usuarios (bottom usuarios)
            IF i > (total_users - 15) THEN
                SET usage_count = FLOOR(1 + RAND() * 5); -- Usuarios poco frecuentes
            END IF;
            
            SET j = 1;
            WHILE j <= usage_count DO
                -- Fecha de uso entre 1 y 90 días atrás
                SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 90) DAY);
                
                -- Duración de sesión entre 5 y 120 minutos (en segundos)
                SET @session_duration = FLOOR(300 + RAND() * 7200);
                
                INSERT INTO appusage (
                    userid,
                    logindate,
                    logoutdate,
                    sessionduration,
                    actionsperformed,
                    ipaddress
                )
                VALUES (
                    i,
                    random_date,
                    DATE_ADD(random_date, INTERVAL @session_duration SECOND),
                    @session_duration,
                    FLOOR(1 + RAND() * 100), -- Acciones realizadas
                    CONCAT('192.168.', FLOOR(1 + RAND() * 254), '.', FLOOR(1 + RAND() * 254))
                );
                
                SET j = j + 1;
            END WHILE;
        END IF;
        
        SET i = i + 1;
    END WHILE;
    
    -- 13. Generar conversaciones, interacciones y transcripciones
    SET i = 1;
    WHILE i <= total_users DO
        -- Solo crear datos para usuarios activos
        SELECT isactive INTO @is_active FROM users WHERE userid = i;
        
        IF @is_active = 1 THEN
            -- Crear entre 1 y 10 conversaciones por usuario
            SET @conversation_count = FLOOR(1 + RAND() * 10);
            
            SET j = 1;
            WHILE j <= @conversation_count DO
                -- Fecha de conversación entre 1 y 90 días atrás
                SET random_date = DATE_SUB(NOW(), INTERVAL FLOOR(1 + RAND() * 90) DAY);
                
                INSERT INTO conversations (
                    idconversations,
                    startdate,
                    enddate,
                    status,
                    lastmessagge,
                    language,
                    userid
                )
                VALUES (
                    (i * 100) + j, -- ID único
                    random_date,
                    DATE_ADD(random_date, INTERVAL FLOOR(5 + RAND() * 120) MINUTE),
                    CASE 
                        WHEN RAND() > 0.1 THEN 'finalizada'
                        WHEN RAND() > 0.5 THEN 'activa'
                        ELSE 'fallida'
                    END,
                    'Último mensaje de la conversación',
                    CASE 
                        WHEN RAND() > 0.3 THEN 'es'
                        ELSE 'en'
                    END,
                    i
                );
                
                -- ID de la conversación
                SET @conversation_id = (i * 100) + j;
                
                -- Crear interacciones y transcripciones para esta conversación
                SET @interaction_count = FLOOR(1 + RAND() * 20);
                
                SET k = 1;
                WHILE k <= @interaction_count DO
                    -- Simular archivos
                    INSERT INTO files (
                        idfile,
                        file_name,
                        file_type,
                        storage_url,
                        update_date,
                        entityid
                    )
                    VALUES (
                        (@conversation_id * 1000) + k, -- ID único
                        CONCAT('audio_', @conversation_id, '_', k, '.mp3'),
                        'recording',
                        CONCAT('https://storage/recordings/', @conversation_id, '_', k, '.mp3'),
                        DATE_ADD(random_date, INTERVAL k MINUTE),
                        1 -- Entityid (solo para relacionar)
                    );
                    
                    -- Crear interacción
                    INSERT INTO conversationinteractions (
                        idinteractions,
                        sequencenumber,
                        datetime,
                        idfile,
                        idconversations
                    )
                    VALUES (
                        (@conversation_id * 1000) + k, -- ID único
                        k,
                        DATE_ADD(random_date, INTERVAL k MINUTE),
                        (@conversation_id * 1000) + k, -- file ID
                        @conversation_id
                    );
                    
                    -- Crear transcripción
                    INSERT INTO transcription (
                        idtranscription,
                        fulltranscript,
                        audiofilename,
                        createddate,
                        status,
                        idinteractions
                    )
                    VALUES (
                        (@conversation_id * 1000) + k, -- ID único
                        CONCAT('Transcripción del audio ', k, ' en la conversación'),
                        CONCAT('audio_', @conversation_id, '_', k, '.mp3'),
                        DATE_ADD(random_date, INTERVAL k MINUTE),
                        CASE WHEN RAND() > 0.1 THEN 'completado' ELSE 'fallido' END,
                        (@conversation_id * 1000) + k
                    );
                    
                    -- Generar algunos errores para la transcripción
                    IF RAND() > 0.6 THEN -- 40% de probabilidad de error
                        -- Decidir cuántos errores generar (1-3)
                        SET error_count = FLOOR(1 + RAND() * 3);
                        
                        SET @error_iter = 1;
                        WHILE @error_iter <= error_count DO
                            INSERT INTO transcriptionerrors (
                                iderrors,
                                errorcode,
                                errortype,
                                trytime,
                                errordescription,
                                idtranscription,
                                errorclassid
                            )
                            VALUES (
                                ((@conversation_id * 1000) + k) * 10 + @error_iter, -- ID único
                                CONCAT('ERR-', FLOOR(100 + RAND() * 900)),
                                CASE 
                                    WHEN RAND() > 0.7 THEN 'critical'
                                    WHEN RAND() > 0.4 THEN 'warning'
                                    ELSE 'info'
                                END,
                                DATE_ADD(random_date, INTERVAL k MINUTE),
                                CASE 
                                    WHEN @error_iter = 1 THEN 'Error reconociendo entidad de pago'
                                    WHEN @error_iter = 2 THEN 'Error interpretando monto'
                                    ELSE 'Error manteniendo contexto'
                                END,
                                (@conversation_id * 1000) + k, -- ID transcripción
                                FLOOR(1 + RAND() * 7) -- Clase de error
                            );
                            
                            SET @error_iter = @error_iter + 1;
                        END WHILE;
                    END IF;
                    
                    SET k = k + 1;
                END WHILE;
                
                SET j = j + 1;
            END WHILE;
        END IF;
        
        SET i = i + 1;
    END WHILE;

END //

DELIMITER ;
