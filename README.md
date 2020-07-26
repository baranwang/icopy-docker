# iCopy Docker 一键启动版

## 🍚 食用方法

### 安装 Docker

参看 [Install Docker Engine](https://docs.docker.com/engine/install/)

对于新手推荐使用一键安装脚本

```sh
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

### 建立配置文件

创建一个 `.env` 文件，键入以下配置，其中除 `SA_GIT_URL` 为 sa 文件的 git 地址外，其他均等同于 iCopy 配置文件

```shell
SA_GIT_URL=https://<name>:<password>@github.com/<name>/<repository>

TG_TOKEN=123456:abcdefg
TG_ID=123456

DB_CONNECT_METHOD=mongodb+srv
DB_ADDR=cluster0.foo.bar.mongodb.net
DB_PORT=27017
DB_NAME=iCopy
DB_USER=<user>
DB_PASSWD=<password>

LANGUAGE=cn
PARALLEL_CHECKERS=512
PARALLEL_TRANSFERS=1024
MIN_SLEEP=1ms
```

### 启动

```sh
docker run -d --env-file .env baranwang/icopy:latest
```
