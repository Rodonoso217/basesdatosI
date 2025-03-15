# entregable#1
Rodrigo Sebastian Donoso Chaves-2024070154

Adrian Josue Barquero Sanchez-2024146907

Tabla de identidades: 

•	users: Almacena información de usuarios del sistema. PK: userid (INT)

•	userroles: Relaciona usuarios con sus roles asignados. PK: roleid(int), userid(INT)

•	roles: Catálogo de roles disponibles en el sistema. PK: roleid(int)

•	permissions: Catálogo de permisos individuales. PK: permissionid(INT) FK: moduleid(INT) 

•	rolepermissions: Relación muchos a muchos entre roles y permisos. PK: rolepermissionid(INT) FK: permissionid(INT), roleid(int) 

•	userpermissions: Permisos específicos asignados directamente a usuarios. PK: rolepermissionid(INT) FK: permissionid(INT), userid(INT) 

•	plans: Planes o paquetes disponibles para suscripción. PK: plansid (TINYINT) 

•	planfeatures: Características específicas de cada plan. PK: featureid(TINYINT) FK: plansid(INT)

•	planpricing: Precios y periodos de facturación para los planes. PK: priceid(TINYINT) FK: plansid(TINYINT), currencyid(TINYINT) 

•	planxperson: Asignación de características de plan a personas específicas. PK: planxpersonid(TINYINT) FK: iduserssubcriptions(INT), featureid(TINYINT) 

•	usersubscriptions: Registro de suscripciones activas de usuarios. PK: usersubsid(INT) FK: userid(INT),plansid(TINYINT),priceid(TINYINT) 

•	paymentmethods: Catálogo de métodos de pago disponibles. PK: paymentmethodid(TINYINT) 

•	userpaymentmethods: Métodos de pago configurados por cada usuario. PK: userpaymentmethodsid(INT) FK: userid(INT), paymentmethod(TINYINT) 

•	payments: Registro de pagos realizados en el sistema. PK: paymentsid(TINYINT) FK: userid(INT), userpaymentmethodsid(INT) 

•	transactions: Registro de transacciones financieras. PK: trnasactionsid(INT) FK: paymentsid(TINYINT) 

•	transactionType: Tipos de transacciones disponibles. PK: transTypeId(TINYINT) FK: transactionsid(INT) 

•	transactionSubTypes: Subtipos específicos de transacciones. PK: transactionSuvTypesId(TINYINT) FK: transactionid(INT)

•	currencies: Catálogo de monedas soportadas por el sistema. PK: currencyId(TINYINT) FK: transactionid(INT) 

•	exchangeRate: Tasas de cambio entre diferentes monedas. PK:exchangeRateID (TINYINT) FK: currencyid(TINYINT) 

•	notificationtype: Tipos de notificaciones configurados. PK: notificationtypeid(TINYINT) 

•	notificationtemplate: Plantillas para los diferentes tipos de notificaciones. PK: templateid(TINYINT) FK:notificationid(TINYINT) 

•	notifications: Registro de notificaciones enviadas. PK: idnotifications(INT) FK: userid(INT),templateid(TINYINT) 

•	files: Registro de archivos almacenados en el sistema. PK: idfile(INT) FK:userid(INT) 

•	languages: Idiomas disponibles en el sistema. PK: languageid(TINYINT) 

•	translation: Traducciones para la internacionalización del sistema. PK: translationid(TINYINT) FK: moduleid(INT), languageid(TINYINT)

•	modules: Módulos funcionales del sistema. PK: moduleid(INT) 

•	logs: Registro de actividades y eventos del sistema. PK: logid(TINYINT) FK: logtypeid(TINYINT), logsourceid(TINYINT), logseverity(TINYINT), userid(INT)

•	logseverity: Niveles de severidad para las entradas de log. PK: logseverityid (TINYINT) 

•	logtypes: Tipos de entradas de log. PK: logtypeid(TINYINT) 

•	logsources: Fuentes u orígenes de las entradas de log. PK:logsourceid(TINYINT)


Ahora explicaremos más a fondo las principales identidades:

Users: esta identidad es primordial para el funcionamiento de la app. Es en donde se guarda toda la información del cliente, desde la información que se usa para identificar el usuario, el id, como datos que se podrían usar luego como email, nombre, la fecha de registro y la contraseña. Esta es la base del proyecto y se conecta con varias identidades como los userroles, usersubscriptions, userpermisions, userpaymentmethod. Es bastante simple, pero a su vez bastante importante.

Roles: Identidad que almacena los diferentes tipos de roles que pueden tener los usuarios en el sistema. Cada rol define un conjunto de permisos y capacidades dentro de la aplicación. Se conecta con userroles para asignar roles a usuarios específicos y con rolepermissions para definir qué permisos tiene cada rol. Es fundamental para el sistema de seguridad y control de acceso.

Permissions: Esta entidad contiene la lista de todas las acciones posibles que se pueden realizar en el sistema. Cada permiso representa una capacidad específica como crear, leer, modificar o eliminar recursos. Se relaciona con roles a través de rolepermissions y directamente con usuarios mediante userpermissions. Forma la base del sistema de autorización granular del proyecto.

Plans: Entidad central para el modelo de negocio que almacena los diferentes planes o suscripciones que ofrece la aplicación. Contiene información como el nombre del plan, su descripción y estado. Se conecta con planfeatures para definir sus características, con planpricing para establecer sus precios y con usersubscriptions para registrar quién está suscrito a qué plan. Es esencial para la monetización del servicio.

Payments: Registra todas las transacciones financieras realizadas por los usuarios. Almacena información como el monto, fecha, método de pago utilizado, estado, descripción, referencias y errores si los hubiera. Se relaciona con usersubscriptions, userpaymentmethods y transactions. Es crucial para el seguimiento financiero y la conciliación de pagos del sistema.

Transactions: Entidad que registra los movimientos financieros a un nivel más detallado que payments. Incluye información sobre el tipo de transacción, monto, estado, descripción y referencias. Se conecta con transactionType y transactionSubTypes para categorizar cada movimiento. Es vital para la auditoría financiera y reportes contables del sistema.

Currencies: Almacena la información de las diferentes monedas soportadas por la aplicación. Incluye datos como código, nombre, símbolo y país. Se relaciona con payments, planpricing y exchangeRate. Es fundamental para la internacionalización financiera del sistema, permitiendo operar en diferentes divisas.

Notifications: Registra todas las comunicaciones enviadas a los usuarios. Contiene información sobre el destinatario, contenido, estado, fecha de envío y plantilla utilizada. Se conecta con notificationtemplate y notificationtype para determinar el formato y categoría de cada notificación. Es esencial para la comunicación con los usuarios y el seguimiento de interacciones.

Files: Esta entidad gestiona todos los archivos subidos al sistema. Almacena datos como la ruta de almacenamiento, tipo de archivo, nombre, tamaño y usuario propietario. Puede relacionarse con múltiples entidades según las necesidades de la aplicación. Es fundamental para el almacenamiento y gestión de documentos y recursos multimedia.

Languages: Contiene los idiomas disponibles en la aplicación. Almacena información como código de idioma, nombre y cultura. Se conecta con translation para proporcionar las traducciones correspondientes. Es clave para la internacionalización de la interfaz y contenidos del sistema.

Translations: Registra todas las traducciones de textos y etiquetas de la aplicación. Contiene el texto traducido, la clave de referencia, el idioma y el módulo al que pertenece. Se relaciona con languages y modules. Es esencial para ofrecer una experiencia multilingüe a los usuarios de diferentes regiones.

Logs: Entidad que registra todas las actividades y eventos del sistema. Almacena información como usuario, acción realizada, fecha, severidad, fuente y detalles adicionales. Se conecta con logseverity, logtypes y logsources para clasificar cada entrada. Es crítica para la auditoría, diagnóstico de problemas y monitoreo de seguridad de la aplicación.

