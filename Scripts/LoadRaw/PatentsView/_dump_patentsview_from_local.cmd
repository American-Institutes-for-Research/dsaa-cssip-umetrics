@echo off

echo.
echo This file will create a dump of the entire PatentView database, including
echo database creation.
echo.

setlocal

set _mysqldump_path=C:\Program Files (x86)\MySQL\MySQL Workbench 6.0 CE\

set _mysql_username=
set _mysql_password=
set _mysql_host=
set _mysql_database=PatentsView

rem Generate a (hopefully unique) destination file name.
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
for /f "tokens=1-4 delims=:." %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c-%%d)
set _filename=%_mysql_database%-%mydate%-%mytime%.sql
set _filename=%_filename: =0%

"%_mysqldump_path%mysqldump.exe" --routines --add-drop-database -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" -B "%_mysql_database%" > %_filename%

echo Dump complete.  Your dump file is named:
echo   %_filename%
echo.
echo Enjoy!
echo.

endlocal

pause
