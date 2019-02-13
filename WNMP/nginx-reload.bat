@echo off
chcp 65001
mode con Cols=50 lines=10
color 0a
title Nginx

echo %~dp0nginx
echo %~dp0config\nginx\nginx.conf
echo %~dp0nginx\logs\nginx.pid
echo 重新加载 Nginx 配置文件。

cd /D %~dp0nginx
nginx -s reload

if errorlevel 1 goto error
goto finish

:error
echo.
echo 重新加载 Nginx 配置文件 失败
pause
cd /D %~dp0

:finish
cd /D %~dp0