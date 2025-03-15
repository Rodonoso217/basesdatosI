# entregable#1
Tabla de identidades: 
•	users: Almacena información de usuarios del sistema 
•	userroles: Relaciona usuarios con sus roles asignados 
•	roles: Catálogo de roles disponibles en el sistema 
•	permissions: Catálogo de permisos individuales 
•	rolepermissions: Relación muchos a muchos entre roles y permisos 
•	userpermissions: Permisos específicos asignados directamente a usuarios 
•	plans: Planes o paquetes disponibles para suscripción 
•	planfeatures: Características específicas de cada plan 
•	planpricing: Precios y periodos de facturación para los planes 
•	planxperson: Asignación de características de plan a personas específicas 
•	usersubscriptions: Registro de suscripciones activas de usuarios 
•	paymentmethods: Catálogo de métodos de pago disponibles 
•	userpaymentmethods: Métodos de pago configurados por cada usuario 
•	payments: Registro de pagos realizados en el sistema 
•	transactions: Registro de transacciones financieras 
•	transactionType: Tipos de transacciones disponibles 
•	transactionSubTypes: Subtipos específicos de transacciones 
•	currencies: Catálogo de monedas soportadas por el sistema 
•	exchangeRate: Tasas de cambio entre diferentes monedas 
•	notificationtype: Tipos de notificaciones configurados 
•	notificationtemplate: Plantillas para los diferentes tipos de notificaciones 
•	notifications: Registro de notificaciones enviadas 
•	files: Registro de archivos almacenados en el sistema 
•	languages: Idiomas disponibles en el sistema 
•	translation: Traducciones para la internacionalización del sistema 
•	modules: Módulos funcionales del sistema 
•	logs: Registro de actividades y eventos del sistema 
•	logseverity: Niveles de severidad para las entradas de log 
•	logtypes: Tipos de entradas de log 
•	logsources: Fuentes u orígenes de las entradas de log

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

