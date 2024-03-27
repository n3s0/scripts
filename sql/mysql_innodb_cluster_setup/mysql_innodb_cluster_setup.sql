CREATE USER 'icadmin'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT ALL PRIVILEGES ON *.* TO 'icadmin'@'%' WITH GRANT OPTION;

GRANT SELECT ON mysql_innodb_cluster_metadata.* TO 'icadmin'@'%';
GRANT SELECT ON mysql.slave_master_info TO 'icadmin'@'%';
GRANT SELECT ON mysql.user TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.global_status TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.global_variables TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_applier_configuration TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_applier_status TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_applier_status_by_coordinator TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_applier_status_by_worker TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_connection_configuration TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_connection_status TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_group_member_stats TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.replication_group_members TO 'icadmin'@'%';
GRANT SELECT ON performance_schema.threads TO 'icadmin'@'%' WITH GRANT OPTION;
