#!/bin/sh
echo "rAthena Development Team presents"
echo "           ___   __  __"
echo "     _____/   | / /_/ /_  ___  ____  ____ _"
echo "    / ___/ /| |/ __/ __ \/ _ \/ __ \/ __  /"
echo "   / /  / ___ / /_/ / / /  __/ / / / /_/ /"
echo "  /_/  /_/  |_\__/_/ /_/\___/_/ /_/\__,_/"
echo ""
echo "http://rathena.org/board/"
echo ""
DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Initalizing rAthena container..."

check_database_exist () {
  RESULT=`mysqlshow --user=${MYSQL_USER} --password=${MYSQL_PWD} --host=${MYSQL_HOST} ${MYSQL_DB} | grep -v Wildcard | grep -o ${MYSQL_DB} | tail -n 1`
  if [ "$RESULT" == "${MYSQL_DB}" ]; then
    return 0;
  else
    return 1;
  fi
}

setup_init () {
  if ! [ -z "${SERVER_MOTD}" ]; then echo -e "${SERVER_MOTD}" > /opt/rAthena/conf/motd.txt; fi
  setup_mysql_config
  setup_config
}

setup_mysql_config () {
  echo "###### MySQL setup ######"
  if [ -z "${MYSQL_HOST}" ]; then echo "Missing MYSQL_HOST environment variable. Unable to continue."; exit 1; fi
  if [ -z "${MYSQL_DB}" ]; then echo "Missing MYSQL_DB environment variable. Unable to continue."; exit 1; fi
  if [ -z "${MYSQL_USER}" ]; then echo "Missing MYSQL_USER environment variable. Unable to continue."; exit 1; fi
  if [ -z "${MYSQL_PWD}" ]; then echo "Missing MYSQL_PWD environment variable. Unable to continue."; exit 1; fi

  echo "Setting up MySQL on Login Server..."
  echo -e "use_sql_db: yes\n\n" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "login_server_ip: ${MYSQL_HOST}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "login_server_db: ${MYSQL_DB}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "login_server_id: ${MYSQL_USER}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "login_server_pw: ${MYSQL_PWD}\n" >> /opt/rAthena/conf/import/inter_conf.txt

  echo "Setting up MySQL on Map Server..."
  echo -e "map_server_ip: ${MYSQL_HOST}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "map_server_db: ${MYSQL_DB}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "map_server_id: ${MYSQL_USER}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "map_server_pw: ${MYSQL_PWD}\n" >> /opt/rAthena/conf/import/inter_conf.txt

  echo "Setting up MySQL on Char Server..."
  echo -e "char_server_ip: ${MYSQL_HOST}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "char_server_db: ${MYSQL_DB}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "char_server_id: ${MYSQL_USER}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "char_server_pw: ${MYSQL_PWD}\n" >> /opt/rAthena/conf/import/inter_conf.txt

  echo "Setting up MySQL on IP ban..."
  echo -e "ipban_db_ip: ${MYSQL_HOST}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "ipban_db_db: ${MYSQL_DB}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "ipban_db_id: ${MYSQL_USER}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "ipban_db_pw: ${MYSQL_PWD}\n" >> /opt/rAthena/conf/import/inter_conf.txt

  echo "Setting up MySQL on log..."
  echo -e "log_db_ip: ${MYSQL_HOST}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "log_db_db: ${MYSQL_DB}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "log_db_id: ${MYSQL_USER}" >> /opt/rAthena/conf/import/inter_conf.txt
  echo -e "log_db_pw: ${MYSQL_PWD}\n" >> /opt/rAthena/conf/import/inter_conf.txt

  echo "DROP FOUND, REMOVING EXISTING DATABASE..."
  if ! [ -z ${MYSQL_DROP_DB} ]; then
    if [ ${MYSQL_DROP_DB} -ne 0 ]; then
      mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -e "DROP DATABASE ${MYSQL_DB};"
    fi
  fi

  echo "Checking if database already exists..."
  if ! check_database_exist; then
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -e "CREATE DATABASE ${MYSQL_DB};"
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/main.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/logs.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_db.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_db2.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_db_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_db2_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_cash_db.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/item_cash_db2.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_db.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_db2.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_db_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_db2_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_skill_db.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_skill_db2.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_skill_db_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/mob_skill_db2_re.sql
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} < /opt/rAthena/sql-files/roulette_default_data.sql

    # edit connection user credentials
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} -e "UPDATE login SET userid = \"${SERVER_INTERSRV_USERID}\", user_pass = \"${SERVER_INTERSRV_PASSWD}\" WHERE account_id = 1;"

    2000000
    # add gamemaster account
    mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h ${MYSQL_HOST} -D${MYSQL_DB} -e "INSERT INTO login (account_id, userid, user_pass, sex, email, group_id, state, unban_time, expiration_time, logincount, lastlogin, last_ip, birthdate, character_slots, pincode, pincode_change, vip_time, old_group) VALUES ('2000000', '${SERVER_GM_USER}', '${SERVER_GM_PASSWD}', 'M', 'athena@athena.com', '99', '0', '0', '0', '0', NULL, '', NULL, '0', '', '0', '0', '0');"
  fi
}

setup_config () {
  echo "###### Config setup ######"
  if ! [ -z "${SERVER_INTERSRV_USERID}" ]; then
    echo -e "userid: ${SERVER_INTERSRV_USERID}" >> /opt/rAthena/conf/import/map_conf.txt
    echo -e "userid: ${SERVER_INTERSRV_USERID}" >> /opt/rAthena/conf/import/char_conf.txt
  fi
  if ! [ -z "${SERVER_INTERSRV_PASSWD}" ]; then
    echo -e "passwd: ${SERVER_INTERSRV_PASSWD}" >> /opt/rAthena/conf/import/map_conf.txt
    echo -e "passwd: ${SERVER_INTERSRV_PASSWD}" >> /opt/rAthena/conf/import/char_conf.txt
  fi

  echo "Applying network configs..."
  if ! [ -z "${NETWORK_CHAR_TO_LOGIN_IP}" ]; then echo -e "login_ip: ${NETWORK_CHAR_TO_LOGIN_IP}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${NETWORK_CHAR_PUBLIC_IP}" ]; then echo -e "char_ip: ${NETWORK_CHAR_PUBLIC_IP}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${NETWORK_MAP_TO_CHAR_IP}" ]; then echo -e "char_ip: ${NETWORK_MAP_TO_CHAR_IP}" >> /opt/rAthena/conf/import/map_conf.txt; fi
  if ! [ -z "${NETWORK_MAP_PUBLIC_IP}" ]; then echo -e "map_ip: ${NETWORK_MAP_PUBLIC_IP}" >> /opt/rAthena/conf/import/map_conf.txt; fi
  if ! [ -z "${NETWORK_ADD_SUBNET_MAP1}" ]; then echo -e "subnet: ${NETWORK_ADD_SUBNET_MAP1}" >> /opt/rAthena/conf/subnet_athena.conf; fi
  if ! [ -z "${NETWORK_ADD_SUBNET_MAP2}" ]; then echo -e "subnet: ${NETWORK_ADD_SUBNET_MAP2}" >> /opt/rAthena/conf/subnet_athena.conf; fi
  if ! [ -z "${NETWORK_ADD_SUBNET_MAP3}" ]; then echo -e "subnet: ${NETWORK_ADD_SUBNET_MAP3}" >> /opt/rAthena/conf/subnet_athena.conf; fi

  echo "Applying server configs..."
  if ! [ -z "${SERVER_NAME}" ]; then echo -e "server_name: ${SERVER_NAME}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_MAX_CONNECT_USER}" ]; then echo -e "max_connect_user: ${SERVER_MAX_CONNECT_USER}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_CHAR_NEW}" ]; then echo -e "char_new: ${SERVER_CHAR_NEW}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_ZENY}" ]; then echo -e "start_zeny: ${SERVER_START_ZENY}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_POINT}" ]; then echo -e "start_point: ${SERVER_START_POINT}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_POINT_PRE}" ]; then echo -e "start_point_pre: ${SERVER_START_POINT_PRE}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_POINT_DORAM}" ]; then echo -e "start_point_doram: ${SERVER_START_POINT_DORAM}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_ITEMS}" ]; then echo -e "start_items: ${SERVER_START_ITEMS}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_START_ITEMS_DORAM}" ]; then echo -e "start_items_doram: ${SERVER_START_ITEMS_DORAM}" >> /opt/rAthena/conf/import/char_conf.txt; fi
  if ! [ -z "${SERVER_PINCODE_ENABLED}" ]; then echo -e "pincode_enabled: ${SERVER_PINCODE_ENABLED}" >> /opt/rAthena/conf/import/char_conf.txt; fi

  if ! [ -z "${SERVER_LOGIN_ALLOWED_REGS}" ]; then echo -e "allowed_regs: ${SERVER_LOGIN_ALLOWED_REGS}" >> /opt/rAthena/conf/import/login_conf.txt; fi
  if ! [ -z "${SERVER_LOGIN_TIME_ALLOWED}" ]; then echo -e "time_allowed: ${SERVER_LOGIN_TIME_ALLOWED}" >> /opt/rAthena/conf/import/login_conf.txt; fi
  if ! [ -z "${SERVER_LOGIN_MD5_PASSWD}" ]; then echo -e "use_MD5_passwords: ${SERVER_LOGIN_MD5_PASSWD}" >> /opt/rAthena/conf/import/login_conf.txt; fi

  echo "Applying server configs..."
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_COMMON}" ]; then echo -e "item_rate_common: ${CONFIG_DROPS_ITEM_RATE_COMMON}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_COMMON_BOSS}" ]; then echo -e "item_rate_common_boss: ${CONFIG_DROPS_ITEM_RATE_COMMON_BOSS}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_COMMON_MVP}" ]; then echo -e "item_rate_common_mvp: ${CONFIG_DROPS_ITEM_RATE_COMMON_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_HEAL}" ]; then echo -e "item_rate_heal: ${CONFIG_DROPS_ITEM_RATE_HEAL}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_HEAL_BOSS}" ]; then echo -e "item_rate_heal_boss: ${CONFIG_DROPS_ITEM_RATE_HEAL_BOSS}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_HEAL_MVP}" ]; then echo -e "item_rate_heal_mvp: ${CONFIG_DROPS_ITEM_RATE_HEAL_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_USE}" ]; then echo -e "item_rate_use: ${CONFIG_DROPS_ITEM_RATE_USE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_USE_BOSS}" ]; then echo -e "item_rate_boss: ${CONFIG_DROPS_ITEM_RATE_USE_BOSS}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_USE_MVP}" ]; then echo -e "item_rate_use_mvp: ${CONFIG_DROPS_ITEM_RATE_USE_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_EQUIP}" ]; then echo -e "item_rate_equip: ${CONFIG_DROPS_ITEM_RATE_EQUIP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_EQUIP_BOSS}" ]; then echo -e "item_rate_equip_boss: ${CONFIG_DROPS_ITEM_RATE_EQUIP_BOSS}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_EQUIP_MVP}" ]; then echo -e "item_rate_equip_mvp: ${CONFIG_DROPS_ITEM_RATE_EQUIP_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_CARD}" ]; then echo -e "item_rate_card: ${CONFIG_DROPS_ITEM_RATE_CARD}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_CARD_BOSS}" ]; then echo -e "item_rate_card_boss: ${CONFIG_DROPS_ITEM_RATE_CARD_BOSS}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_CARD_MVP}" ]; then echo -e "item_rate_card_mvp: ${CONFIG_DROPS_ITEM_RATE_CARD_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_MVP}" ]; then echo -e "item_rate_mvp: ${CONFIG_DROPS_ITEM_RATE_MVP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_ADDDROP}" ]; then echo -e "item_rate_adddrop: ${CONFIG_DROPS_ITEM_RATE_ADDDROP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_DROPS_ITEM_RATE_TREASURE}" ]; then echo -e "item_rate_treasure: ${CONFIG_DROPS_ITEM_RATE_TREASURE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_BASE_EXP_RATE}" ]; then echo -e "base_exp_rate: ${CONFIG_EXP_BASE_EXP_RATE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_JOB_EXP_RATE}" ]; then echo -e "job_exp_rate: ${CONFIG_EXP_JOB_EXP_RATE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_MULTI_LEVEL_UP}" ]; then echo -e "multi_level_up: ${CONFIG_EXP_MULTI_LEVEL_UP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_MVP_EXP_RATE}" ]; then echo -e "mvp_exp_rate: ${CONFIG_EXP_MVP_EXP_RATE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_QUEST_EXP_RATE}" ]; then echo -e "quest_exp_rate: ${CONFIG_EXP_QUEST_EXP_RATE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_HEAL_EXP}" ]; then echo -e "heal_exp: ${CONFIG_EXP_HEAL_EXP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_RESURRECTION_EXP}" ]; then echo -e "resurrection_exp: ${CONFIG_EXP_RESURRECTION_EXP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_SHOP_EXP}" ]; then echo -e "shop_exp: ${CONFIG_EXP_SHOP_EXP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_PVP_EXP}" ]; then echo -e "pvp_exp: ${CONFIG_EXP_PVP_EXP}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_DEATH_PENALTY_TYPE}" ]; then echo -e "death_penalty_type: ${CONFIG_EXP_DEATH_PENALTY_TYPE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_DEATH_PENALTY_BASE}" ]; then echo -e "death_penalty_base: ${CONFIG_EXP_DEATH_PENALTY_BASE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_DEATH_PENALTY_JOB}" ]; then echo -e "death_penalty_job: ${CONFIG_EXP_DEATH_PENALTY_JOB}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_ZENY_PENALTY}" ]; then echo -e "zeny_penalty: ${CONFIG_EXP_ZENY_PENALTY}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
  if ! [ -z "${CONFIG_EXP_DISP_EXPERIENCE}" ]; then echo -e "disp_experience: ${CONFIG_EXP_DISP_EXPERIENCE}" >> /opt/rAthena/conf/import/battle_conf.txt; fi
}

cd /opt/rAthena
if ! [ -z ${DOWNLOAD_OVERRIDE_CONF_URL} ]; then
  wget -q ${DOWNLOAD_OVERRIDE_CONF_URL} -O /tmp/rathena_import_conf.zip
  if [ $? -eq 0 ]; then
    unzip /tmp/rathena_import_conf.zip -d /opt/rAthena/conf/import/
    if ! [ $? -eq 0 ]; then
      setup_init
    fi
  else
    setup_init
  fi
else
  setup_init
fi

exec "$@"
