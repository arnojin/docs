@echo off
chcp 65001
mode con Cols=50 lines=10
color 0a
title Nginx

echo %~dp0nginx
echo %~dp0config\nginx\nginx.conf
echo %~dp0nginx\logs\nginx.pid
echo 已启动 Nginx，请使用 nginx_quit.bat 退出。

cd /D %~dp0nginx
nginx -c %~dp0config\nginx\nginx.conf

if errorlevel 1 goto error
goto finish

:error
echo.
echo 启动 Nginx 失败
pause
cd /D %~dp0

:finish
cd /D %~dp0