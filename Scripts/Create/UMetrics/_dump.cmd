@echo on

setlocal

set _mysqldump_path=C:\Program Files (x86)\MySQL\MySQL Workbench 6.0 CE\

set _mysql_username=
set _mysql_password=
set _mysql_host=mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com
set _mysql_database=UMetrics

REM Create Database Script
"%_mysqldump_path%mysqldump.exe" --no-data --add-drop-database --no-create-info -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -B "%_mysql_database%" > CreateDatabase.sql

REM Create Table Scripts
"%_mysqldump_path%mysqldump.exe" --no-data --add-drop-database -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -T. "%_mysql_database%"

endlocal

pause
