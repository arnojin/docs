@echo off
chcp 65001
mode con Cols=130 lines=40
color 0a
title MariaDB

echo %~dp0mariadb
echo %~dp0mariadb\data
echo %~dp0mariadb\data\%computername%.pid
echo %~dp0config\mariadb\my.ini
echo 退出 MariaDB。

:run
cd /D %~dp0
%~dp0mariadb\bin\mysqladmin -u root shutdown

if errorlevel 1 goto error
goto finish

:error
echo 退出 MariaDB 失败
pause

:finish
