# git 配置

## 生成本地私钥

cd ~/.ssh
ssh-keygen -t rsa -C "username@mail.com" -b 4096

## 配置访问参数

vi ~/.ssh/config
Host gitlab.youdomain.com
User username
Port 22
IdentityFile ~/.ssh/id_rsa

## 配置全局参数

git config --global user.name "username"
git config --global user.email "username@mail.com"

## 粘贴公钥到 gitlab 的SSH setting中

xclip -sel clip < ~/.ssh/id_rsa.pub

## 测试SSH连接

ssh -T git@gitlab.youdomain.com -p 22

## 获取代码

git clone git@gitlab.youdomain.com:groupname/projectname.git