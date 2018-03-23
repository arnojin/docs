# bash

## 硬盘

```bash
# 查看磁盘空间及类型
df -TH
```

## 文件

```bash
# 复制文件到远程主机上
nohup scp -r /dmp/docker/ ip-066.arno.com:/dmp &

# 解压文件到指定路径
tar xzvf /home/arno/docker.tar.gz -C /dmp

# 逐级创建目录
mkdir -p /usr/share/java

# 批量检查日志输出
tail -f /opt/cm-5.13.1/log/cloudera-scm-agent/* /opt/cm-5.13.1/log/cloudera-scm-server/*
```

## 内存

## CPU

## 日期、时间

```bash
# 检查时间服务器同步情况
ntpq -p && ntpstat

# 设置时钟同步，修改时区
yum -y install ntp
systemctl enable ntpd
systemctl start ntpd
systemctl status ntpd
ntpdate -u cn.pool.ntp.org
ntpq -p && ntpstat

localectl set-locale LANG=zh_CN.UTF-8
localectl set-x11-keymap cn
localectl status
localectl list-locales | grep zh_
timedatectl
timedatectl set-local-rtc no

# 时间写入硬件时钟
hwclock -w && hwclock -r

# 格式化日期 2018-1-1 -> 2018-01-01
date -d "2018-1-1" "+%Y-%m-%d"

# 显示格式化的日期、时间 2018-01-01 08:15:01
date "+%Y-%m-%d %H:%M:%S"

# 循环处理 1.1 ~ 1.31 号日期段的数据
startSec=`date -d "2018-01-01" "+%s"`
endSec=`date -d "2018-01-31" "+%s"`
for((i=$startSec;i<=$endSec;i+=$[86400*daySteps]))
do
    beginDay=`date -d "@$i" "+%Y-%m-%d"`
    newSec=$[i+86400*(daySteps-1)]

    echo daySteps=$daySteps
    echo i=$i
    echo newSec=$newSec

    if [ $newSec -gt $endSec ]; then
        endDay=`date -d "@$endSec" "+%Y-%m-%d"`
    else
        endDay=`date -d "@$newSec" "+%Y-%m-%d"`
    fi

    echo "[`date "+%Y-%m-%d %H:%M:%S"`]${beginDay} 到 ${endDay} 号。"

done
```

## 主机

```bash
# 设置主机名称
hostnamectl set-hostname ip-066.arno.com --static
hostnamectl status

# 查看系统版本
uname -a
cat /etc/redhat-release

# 设置主机互认
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
scp –P 22 ~/.ssh/authorized_keys root@ip-066.arno.com:~/.ssh

# 创建服务用户
userdel cloudera-scm
useradd \
    --system \
    --home=/opt/cm-5.13.1/run/cloudera-scm-server \
    --no-create-home \
    --shell=/bin/false \
    --comment "Cloudera SCM User" \
    cloudera-scm
```

## 网络

```bash
# 关闭防火墙和SELinux
systemctl stop firewalld
systemctl status firewalld
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```