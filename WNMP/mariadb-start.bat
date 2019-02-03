@echo off
chcp 65001
mode con Cols=130 lines=40
color 0a
title MariaDB

echo %~dp0mariadb
echo %~dp0mariadb\data
echo %~dp0mariadb\data\%computername%.pid
echo %~dp0config\mariadb\my.ini
echo 已启动 MariaDB，请使用 mariadb-shutdown.bat 退出。

:run
cd /D %~dp0
%~dp0mariadb\bin\mysqld --defaults-file=%~dp0config\mariadb\my.ini --standalone --console

if errorlevel 1 goto error
goto finish

:error
echo 启动 MariaDB 失败
pause

:finish
