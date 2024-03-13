CREATE DATABASE application_name;
CREATE USER 'application_name'@'localhost' IDENTIFIED BY 'db_password';
GRANT ALL PRIVILEGES ON application_name.* TO 'application_name'@'localhost';
FLUSH PRIVILEGES;
