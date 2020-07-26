#!/usr/bin/env sh

if [ $SA_GIT_URL ]; then
  git clone $(echo ${SA_GIT_URL}) accounts
  cd accounts
  SA_FILE=$(ls | head -1)
  # 生成 fclone 配置文件
  echo "
[gc]
type = drive
scope = drive
service_account_file = /app/accounts/${SA_FILE}
service_account_file_path = /app/accounts/
" >/root/.config/rclone/rclone.conf
  # 生成 iCopy 配置文件
  echo "
[tg]
token = '${TG_TOKEN}'
usr_id = '${TG_ID}'
[database]
db_connect_method = '${DB_CONNECT_METHOD}'
db_addr = '${DB_ADDR}'
db_port = ${DB_PORT}
db_name = '${DB_NAME}'
db_user = '${DB_USER}'
db_passwd = '${DB_PASSWD}'
[general]
language = '${BOT_LANGUAGE}'
cloner = 'fclone'
option = 'copy'
remote = 'gc'
parallel_c = '${PARALLEL_CHECKERS}'
parallel_t = '${PARALLEL_TRANSFERS}'
min_sleep = '${MIN_SLEEP}'
sa_path = '/app/accounts'
run_args = ['-P', '--ignore-checksum' , '--stats=1s']
  " >/app/iCopy/config/conf.toml
  cd /app/iCopy/
  python3 iCopy.py
fi
