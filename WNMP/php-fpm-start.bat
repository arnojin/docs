@echo off
chcp 65001
mode con Cols=50 lines=10
color 0a
title PHP-FPM

echo %~dp0php
echo %~dp0config\php\php.ini
echo 已在端口 9001 启动 PHP-FPM，关闭窗口即可退出。

cd /D %~dp0php
php-cgi.exe -b 127.0.0.1:9001 -c %~dp0config\php\php.ini

if errorlevel 1 goto error
goto finish

:error
echo.
echo 启动 PHP-FPM 失败
pause
cd /D %~dp0

:finish
cd /D %~dp0