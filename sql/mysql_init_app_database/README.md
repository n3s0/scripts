# MySQL Initialize App Database

## Summary

Wrote this script as a reference and to automate a common database
configuration. This is solely for MySQL databases that are running in a
local configuration or on the same server as it's purposed application.

This is a little script that will do the following.

- Create a database with the specified name.
- Create a new user a password.
- Grant all privileges on the database.
- Flush privilege tables.

One thing to be aware of. When running this script there are values you
need to change before you run it. Otherwise it wont work as it's
intended.

## Running Script

To run the script you can run the following command.

```sh
mysql -u root -p < mysql_init_app_database.sql
```
