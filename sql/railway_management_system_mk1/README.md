# Railyway Management System Database Design Project

## Summary

This is the scripts repository for a Railway Management System project.

This README provides some overview on how to setup the schema. But, its
purpose isn't for full fledged documentation. Full documentation can be
found at the following link.

- [Railway Management System Database Design Project]()

## MySQL Database Setup

This assumes you know the root password. If you don't please replace
with any privileged account you use to administer your database.

The command below will perform the initial database setup. You may need
the root password in order to complete this.

```bash
mysql -u root -p < rms_init.sql
```

This command will create the database schema on the database server.

```bash
mysql -u root -p rms < rms_schema.sql
```

This command will seed some data into the database to show how the data
is stored.

```bash
mysql -u root -p rms < rms_seeder.sql
```

