@echo off

setlocal

set _mysql_path=C:\Program Files (x86)\MySQL\MySQL Workbench 6.0 CE\

set _mysql_username=
set _mysql_password=
set _mysql_host=
set _mysql_database=uspto

time /t
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_assignee.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_foreigncitation.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_inventor.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_location.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_location_assignee.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_location_inventor.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_patent.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_patent_assignee.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_patent_inventor.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_uspatentcitation.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_uspc.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_rawassignee.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_rawinventor.sql
"%_mysql_path%mysql.exe" -h"%_mysql_host%" -u"%_mysql_username%" -p"%_mysql_password%" "%_mysql_database%" < export_rawlocation.sql
time /t

endlocal

pause
