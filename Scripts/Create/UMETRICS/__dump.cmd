@echo off

setlocal

set _mysqldump_path=C:\Program Files (x86)\MySQL\MySQL Workbench 6.0 CE\

set _mysql_username=mysqladmin
set _mysql_password=
set _mysql_host=mysql-1.c4cgr75mzpo7.us-east-1.rds.amazonaws.com
set _mysql_database=UMETRICS

echo.
echo This script will dump the structure of the database
echo.
echo    %_mysql_database%
echo.
echo as found on MySQL server
echo.
echo    %_mysql_host%
echo.
echo to the current directory.  It will dump both database and table creation
echo scripts, but not data.  The create database script will be named, appropriately
echo enough, _create_database.sql.  The table creation scripts will be named after
echo the tables they create.
echo.
echo A password may be supplied using the _mysql_password variable found in this
echo command file.  If left blank, mysqldump will prompt for a password.  For short
echo scripts, prompting is the better option.  For longer scripts, supplying that
echo value will save a lot of typing, JUST BE SURE TO BLANK OUT THE PASSWORD WHEN
echo FINISHED!!!
echo.
echo One final note... this script always dumps out the AUTO_INCREMENT table option.
echo There is apparently no way to turn that off using mysqldump.  For fresh, clean,
echo AUTO_INCREMENT free tables, some script editing may be required.  Sorry.
echo.
echo Enjoy!
echo.

echo Creating _create_database.sql script
"%_mysqldump_path%mysqldump.exe" --no-data --add-drop-database --no-create-info --skip-dump-date -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -B "%_mysql_database%" --result-file=_create_database.sql

echo Creating _create_procedures.sql script
"%_mysqldump_path%mysqldump.exe" --routines --no-create-db --no-create-info --no-data --skip-dump-date -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -B "%_mysql_database%" --result-file=_create_procedures.sql

echo Create table scripts.
"%_mysqldump_path%mysqldump.exe" --no-data --add-drop-database --skip-dump-date -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -T. "%_mysql_database%"

echo.
echo Finished!
echo.

endlocal

pause
