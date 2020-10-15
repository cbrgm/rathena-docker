targets = server config mysql

all : server

build:
	docker build -t "cbrgm/rathena-server:latest" .

mysql:
	docker run -p 3306 --name "mysql" -e MYSQL_ROOT_PASSWORD="secret" -v "${pwd}/data:/var/lib/mysql" -d mysql:5.7

mysql-stop:
	docker stop mysql; docker rm mysql

rathena:
	docker run -d -p 6900:6900 -p 6121:6121 -p 5121:5121 --restart=unless-stopped --name rathena \
	-e MYSQL_HOST="172.17.0.2" \
	-e MYSQL_USER="root" \
	-e MYSQL_PWD="secret" \
	-e MYSQL_DB="rAthena" \
	-e MYSQL_DROP_DB=0 \
	-e NETWORK_CHAR_TO_LOGIN_IP="127.0.0.1" \
	-e NETWORK_MAP_TO_CHAR_IP="127.0.0.1" \
	-e NETWORK_CHAR_PUBLIC_IP="192.168.188.62" \
	-e NETWORK_MAP_PUBLIC_IP="192.168.188.62" \
	-e NETWORK_ADD_SUBNET_MAP1="" \
	-e SERVER_NAME="NorthRO" \
	-e SERVER_MOTD="Welcome to NorthRO Ragnarok Online!" \
	-e SERVER_INTERSRV_USERID="intersrv" \
	-e SERVER_INTERSRV_PASSWD="intersrv" \
	-e SERVER_MAX_CONNECT_USER=1024 \
	-e SERVER_GM_USER="Godfather" \
	-e SERVER_GM_PASSWD="secret" \
	-e SERVER_CHAR_NEW="yes" \
	-e SERVER_START_ZENY=5000 \
	-e SERVER_START_POINT="prontera,155,182" \
	-e SERVER_START_POINT_PRE="prontera,155,182" \
	-e SERVER_START_POINT_DORAM="" \
	-e SERVER_START_ITEMS="" \
	-e SERVER_START_ITEMS_DORAM="" \
	-e SERVER_PINCODE_ENABLED="no" \
	-e SERVER_LOGIN_ALLOWED_REGS="1" \
	-e SERVER_LOGIN_TIME_ALLOWED="10" \
	-e SERVER_LOGIN_MD5_PASSWD="no" \
	-e SERVER_LOGIN_NEW_ACCOUNT="yes" \
	cbrgm/rathena:latest

rathena-stop:
	docker stop rathena; docker rm rathena
