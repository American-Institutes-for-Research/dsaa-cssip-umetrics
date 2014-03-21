@echo off

setlocal

set _mysqldump_path=C:\Program Files (x86)\MySQL\MySQL Workbench 6.0 CE\

set _mysql_username=
set _mysql_password=
set _mysql_host=

time /t
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto assignee > export_assignee.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto foreigncitation > export_foreigncitation.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto uspatentcitation > export_uspatentcitation.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto inventor > export_inventor.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto location > export_location.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto patent > export_patent.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto uspc > export_uspc.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto location_assignee > export_location_assignee.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto location_inventor > export_location_inventor.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto patent_assignee > export_patent_assignee.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto patent_inventor > export_patent_inventor.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto rawassignee > export_rawassignee.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto rawinventor > export_rawinventor.sql
"%_mysqldump_path%mysqldump.exe" --single-transaction -u"%_mysql_username%" -p"%_mysql_password%" -h"%_mysql_host%" uspto rawlocation > export_rawlocation.sql
time /t

endlocal

pause
