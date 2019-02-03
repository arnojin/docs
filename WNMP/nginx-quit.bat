@echo off
chcp 65001
mode con Cols=100 lines=10
color 0a
title Nginx

echo %~dp0nginx
echo %~dp0config\nginx\nginx.conf
echo %~dp0nginx\logs\nginx.pid
echo 已停止 Nginx。

cd /D %~dp0nginx
nginx -s quit

if errorlevel 1 goto error
goto finish

:error
echo.
echo 停止 Nginx 失败
pause
cd /D %~dp0

:finish
cd /D %~dp0