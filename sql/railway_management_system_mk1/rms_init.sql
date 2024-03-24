CREATE DATABASE rms;
CREATE USER 'rms-admin'@'localhost' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON rms.* TO 'rms-admin'@'localhost';
