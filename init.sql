CREATE DATABASE IF NOT EXISTS main_app_db;
CREATE DATABASE IF NOT EXISTS auth_service_db;
CREATE DATABASE IF NOT EXISTS notification_service_db;
CREATE DATABASE IF NOT EXISTS scraping_service_db;

CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES ON main_app_db.* TO 'user'@'%';
GRANT ALL PRIVILEGES ON auth_service_db.* TO 'user'@'%';
GRANT ALL PRIVILEGES ON notification_service_db.* TO 'user'@'%';
GRANT ALL PRIVILEGES ON scraping_service_db.* TO 'user'@'%';

FLUSH PRIVILEGES;
