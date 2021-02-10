# 在Windows 10下安装Nginx+MariaDB+PHP-FPM(XDebug)

## 下载地址

* [nginx:download](http://nginx.org/en/download.html)
* [Stable version nginx-1.14.2](http://nginx.org/download/nginx-1.14.2.zip)
  * certutil -hashfile nginx-1.14.2.zip sha256
    * 9846d77af7bbf9cf37f5faba8afb0825815c014f992fc719bbfb558b2dde4a1f
* [MariaDB Downloads](https://downloads.mariadb.org/mariadb/+releases/)
* [mariadb-10.3.12-winx64.zip](https://downloads.mariadb.org/interstitial/mariadb-10.3.12/winx64-packages/mariadb-10.3.12-winx64.zip/from/http%3A//mirrors.tuna.tsinghua.edu.cn/mariadb/)
  * certutil -hashfile mariadb-10.3.12-winx64.zip sha256
    * 3c7c31ddf572455213a0d2ddc2b3a0487af41bdc19588191d99142ad9fb73911
* [php Binaries and sources Releases](https://windows.php.net/download)
* [PHP 7.2.14 VC15 x64 Thread Safe](https://windows.php.net/downloads/releases/php-7.2.14-Win32-VC15-x64.zip)
  * certutil -hashfile php-7.2.14-Win32-VC15-x64 sha256
    * f11bd2fc5e1b8034a3e23eb798ad757bdcb94e60df23adf01a1b76ebbc406a36
* [XDEBUG EXTENSION FOR PHP | DOWNLOADS](https://xdebug.org/download.php)
* [XDEBUG EXTENSION FOR PHP | DOCUMENTATION | INSTALLATION](https://xdebug.org/wizard.php)
* [Xdebug 2.6.1 PHP 7.2 VC15 TS (64 bit)](http://xdebug.org/files/php_xdebug-2.6.1-7.2-vc15-x86_64.dll)
  * certutil -hashfile php_xdebug-2.6.1-7.2-vc15-x86_64.dll sha256
    * ae18f7659f55e7bfcf42c782d1cfa11373524630c182de5b882f9e37e8791385

## 安装

### 创建工作目录

```powershell
mkdir d:\work
mkdir d:\work\config
mkdir d:\work\soft
mkdir d:\work\tmp
mkdir d:\work\www
```

### 设置脚本以管理员权限运行

* 双击 D:\work\run-as-admin.reg 向注册表注册
    ```text
    Windows Registry Editor Version 5.00
    
    [HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers]
    "D:\\work\\nginx-start.bat"="~ RUNASADMIN"
    "D:\\work\\nginx-quit.bat"="~ RUNASADMIN"
    "D:\\work\\nginx-reload.bat"="~ RUNASADMIN"
    ```

### 解压文件，创建目录链接

* 解压nginx-1.14.2.zip到d:\work\nginx-1.14.2
* 解压mariadb-10.3.12-winx64.zip到d:\work\mariadb-10.3.12-winx64
* 解压php-7.3.1-Win32-VC15-x64.zip到d:\work\php-7.3.1-Win32-VC15-x64
* 创建链接目录
    ```powershell
    mklink /j d:\work\nginx d:\work\nginx-1.14.2
    mklink /j d:\work\mariadb d:\work\mariadb-10.3.12-winx64
    mklink /j d:\work\php d:\work\php-7.2.14-Win32-VC15-x64
    ```

### 安装 Nginx

* 复制配置文件、默认HTML页面
    ```powershell
    echo d | xcopy /q/s D:\work\nginx\conf D:\work\config\nginx
    echo d | xcopy /q/s D:\work\nginx\html D:\work\www\nginx
    ```
* 更新配置文件 D:\work\config\nginx\nginx.conf
    ```powershell
    mkdir D:\work\config\nginx\conf.d
    ```
    ```text
    worker_processes  4;
    events {
        worker_connections  1024;
    }

    http {
        include       mime.types; # D:\work\config\nginx\mime.types
        default_type  application/octet-stream;
        sendfile        on;
        keepalive_timeout  65;
    
        gzip  on;
        client_max_body_size 300m;
        include conf.d/*.conf; # D:\work\config\nginx\conf.d
    }
    
    ```
* 创建配置文件 D:\work\config\nginx\conf.d\localhost.conf
    ```text
    server {
        listen       80;
        server_name  localhost;
        location / {
            root   D:/work/www/nginx;
            index  index.html index.htm;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   D:/work/www/nginx;
        }
    }
    ```
* 启动
  ```powershell
  D:\work\nginx-start.bat
  ```
* 停止
  ```powershell
  D:\work\nginx-quit.bat
  ```
* 更新配置
  ```powershell
  D:\work\nginx-start.bat
  ```

### 安装 MariaDB

* 创建配置文件 D:\work\config\mariadb\my.ini
    ```bash
    [client]
    default-character-set=utf8
    
    [mysql]
    default-character-set=utf8
    
    [mysqld]
    init_connect='SET collation_connection = utf8_general_ci'
    init_connect='SET NAMES utf8'
    character-set-server=utf8
    collation-server=utf8_general_ci
    skip-character-set-client-handshake
    ```
* 启动
  ```powershell
  D:\work\mariadb-start.bat
  ```
* 停止
  ```powershell
  D:\work\mariadb-shutdown.bat
  ```

### 安装 PHP

* 创建配置文件
    ```powershell
    d:\work\php\php -i > d:\work\phpinfo.txt
    echo f | xcopy /q/s D:\work\php\php.ini-development D:\work\config\php\php.ini
    echo f | xcopy /q/s D:\work\soft\php_xdebug-2.6.1-7.2-vc15-x86_64.dll D:\work\php\ext\php_xdebug-2.6.1-7.2-vc15-x86_64.dll
    ```
* 修改 php.ini ，在文件后追加以下内容
    ```text
    [php]
    max_execution_time = 600
    max_input_time = 600
    post_max_size = 8M
    include_path = "d:\work\php\PEAR"
    extension_dir = "d:\work\php\ext"
    upload_tmp_dir = "d:\work\tmp"
    upload_max_filesize = 20M
    
    extension = bz2
    extension = curl
    extension = fileinfo
    extension = gd2
    extension = gettext
    extension = mbstring
    extension = exif
    extension = mysqli
    extension = pdo_mysql
    extension = pdo_sqlite
    
    asp_tags = Off
    display_startup_errors = On
    track_errors = Off
    y2k_compliance = On
    allow_call_time_pass_reference = Off
    safe_mode = Off
    safe_mode_gid = Off
    safe_mode_allowed_env_vars = PHP_
    safe_mode_protected_env_vars = LD_LIBRARY_PATH
    error_log = "D:\work\php\logs\php_error_log"
    register_globals = Off
    register_long_arrays = Off
    magic_quotes_gpc = Off
    magic_quotes_runtime = Off
    magic_quotes_sybase = Off
    extension = php_openssl.dll
    extension = php_ftp.dll
    
    [Date]
    date.timezone = "Asia/Shanghai"
    
    [Pdo]
    pdo_mysql.default_socket = "MySQL"
    
    ;[browscap]
    ;browscap = "D:\work\php\extras\browscap.ini"
    
    [Session]
    session.save_path = "d:\work\tmp"
    define_syslog_variables=Off
    
    [curl]
    curl.cainfo="D:\work\apache\bin\curl-ca-bundle.crt"
    openssl.cafile="D:\work\apache\bin\curl-ca-bundle.crt"
    
    [Syslog]
    define_syslog_variables=Off
    
    [MySQL]
    mysql.allow_local_infile=On
    mysql.allow_persistent=On
    mysql.cache_size=2000
    mysql.max_persistent=-1
    mysql.max_link=-1
    mysql.default_port=3306
    mysql.default_socket="MySQL"
    mysql.connect_timeout=3
    mysql.trace_mode=Off
    
    [MSSQL]
    mssql.allow_persistent=On
    mssql.max_persistent=-1
    mssql.max_links=-1
    mssql.min_error_severity=10
    mssql.min_message_severity=10
    mssql.compatability_mode=Off
    mssql.secure_connection=Off
    
    [xdebug]
    ; PHP 7.4.15 + php_xdebug-3.0.2-7.4-vc15-x86_64.dll
    ; 部分配置的名称做了如下调整
    zend_extension = "D:/work/php/ext/php_xdebug.dll"
    xdebug.idekey=phpstorm
    xdebug.mode=debug
    xdebug.client_host=localhost
    xdebug.client_port=9003
    xdebug.remote_handler=dbgp
    xdebug.mode=debug
    xdebug.start_with_request=yes
    ```
* 执行脚本
  ```powershell
  D:\work\php-fpm-start.bat
  ```
* 创建配置文件 D:\work\config\nginx\conf.d\demo.local.conf
    ```powershell
    mkdir D:\work\www\demo.local
    ```
    ```text
    server {
        listen       80;
        server_name  demo.local;
        location / {
            root   D:/work/www/demo.local;
            index  index.php;
        }
        location ~ \.php$ {
            root           D:/work/www/demo.local;
            fastcgi_pass   127.0.0.1:9001;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   D:/work/www/demo.local;
        }
    }
    ```
* 创建 php 测试文件 D:\work\www\demo.local\index.php
    ```php
    <?php
    echo __DIR__;
    phpinfo();
    ```
* 修改 hosts 文件，增加以下内容
    ```text
    127.0.0.1 demo.local
    ```
* 通过 http://demo.local/ 测试是否显示了 phpinfo 信息

### 安装 composer

* 安装 composer
    ```powershell
    php -c d:\work\config\php\php.ini -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -c d:\work\config\php\php.ini -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php -c d:\work\config\php\php.ini composer-setup.php --install-dir=D:\work\composer
    php -c d:\work\config\php\php.ini -r "unlink('composer-setup.php');"
    ```

* 增加脚本
    ```powershell
    @d:\work\php\php -c d:\work\config\php\php.ini "%~dp0composer.phar" %*
    composer --version
    ```