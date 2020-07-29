#!/bin/bash

set -e

clear
echo "检查依赖环境…"
if !(docker -v); then
  echo '开始安装 Docker'
  curl -sSL https://get.docker.com/ | sh
fi

clear
echo "选择运行版本"
select version_type in "最新版本" "指定版本"; do
  case $version_type in
  "最新版本")
    docker_version=latest
    break
    ;;
  "指定版本")
    clear
    echo "选择运行版本"
    select docker_version in '0.2.0-beta.6.5' '0.2.0-beta.6.4' '0.2.0-beta.6.3'; do
      break
    done
    break
    ;;
  esac
done

if [ -f "./icopy-docker.env" ]; then
  export $(xargs <./icopy-docker.env)
else
  clear
  echo "选择你的 Service Account 储存方式（本地文件夹选择 local）"
  select SA_TYPE in "local" "git"; do
    clear
    case $SA_TYPE in
    "local")
      echo "输入 Service Account 储存目录的绝对路径（eg: /root/accounts）"
      read SA_DIR
      break
      ;;
    "git")
      echo "输入 Service Account git 仓库地址，隐私仓库应包含 Access Token 或密码（eg: https://<name>:<token_or_password>@github.com/<name>/<repository>）"
      read SA_GIT_URL
      break
      ;;
    esac
  done

  clear
  echo "输入 Telegram 机器人 Token"
  read TG_TOKEN

  clear
  echo "输入你的 Telegram ID"
  read TG_ID

  clear
  echo "选择数据库连接方式"
  select DB_CONNECT_METHOD in mongodb+srv mongodb; do
    break
  done

  clear
  echo "输入数据库地址"
  read DB_ADDR

  clear
  echo "输入数据库端口号（默认：27017）"
  read DB_PORT
  DB_PORT=${DB_PORT:-27017}

  clear
  echo "输入数据库名（默认：iCopy）"
  read DB_NAME
  DB_NAME=${DB_NAME:-iCopy}

  clear
  echo "输入数据库用户名"
  read DB_USER

  clear
  echo "输入数据库密码"
  read DB_PASSWD

  clear
  echo "选择 iCopy 语言"
  select BOT_LANGUAGE in cn eng jp; do
    break
  done

  clear
  echo "输入检查并发量（默认：16）"
  read PARALLEL_CHECKERS
  PARALLEL_CHECKERS=${PARALLEL_CHECKERS:-16}

  clear
  echo "输入传输并发量（默认：32）"
  read PARALLEL_TRANSFERS
  PARALLEL_TRANSFERS=${PARALLEL_TRANSFERS:-32}

  clear
  echo "输入最小休息时间（默认：1ms）"
  read MIN_SLEEP
  MIN_SLEEP=${MIN_SLEEP:-1ms}

  echo "
SA_TYPE=$SA_TYPE
SA_DIR=$SA_DIR
SA_GIT_URL=$SA_GIT_URL

TG_TOKEN=$TG_TOKEN
TG_ID=$TG_ID

DB_CONNECT_METHOD=$DB_CONNECT_METHOD
DB_ADDR=$DB_ADDR
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWD=$DB_PASSWD

BOT_LANGUAGE=$BOT_LANGUAGE
PARALLEL_CHECKERS=$PARALLEL_CHECKERS
PARALLEL_TRANSFERS=$PARALLEL_TRANSFERS
MIN_SLEEP=$MIN_SLEEP
" >icopy-docker.env
fi

clear

echo '正在拉取镜像…'
docker pull baranwang/icopy:${docker_version}
docker stop icopy && docker rm icopy
clear
echo '正在启动镜像…'
case $SA_TYPE in
"local")
  docker run -d --name=icopy --env-file icopy-docker.env -v ${SA_DIR}:/app/accounts baranwang/icopy:${docker_version}
  ;;
"git")
  docker run -d --name=icopy --env-file icopy-docker.env baranwang/icopy:${docker_version}
  ;;
esac
echo 'iCopy 已启动，Enjoy~'
