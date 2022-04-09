#!/bin/sh
# Variable description:
# ====================
# OK_SERVER="Ragnarok Online server to play on found in tables/servers.txt"
# OK_USERNAME="Account username"
# OK_PWD="Account password"
# OK_CHAR="Character slot. Default: 1"
# OK_KILLSTEAL="It is ok that the bot attacks monster that are already being attacked by other players."
# OK_FOLLOW_USERNAME="Name of the username to follow"
# OK_CLASS="Bot specific confix to be used"

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
echo "Initalizing Docker container..."

# Check if variables are set
if [ -z "${OK_SERVER}" ]; then echo "Missing OK_IP environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_USERNAME}" ]; then echo "Missing OK_USERNAME environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_PWD}" ]; then echo "Missing OK_PWD environment variable. Unable to continue."; exit 1; fi
if [ -z "${OK_CHAR}" ]; then OK_CHAR=1; fi

# Check if killsteal is active
if [ "${OK_KILLSTEAL}" == "1" ]; then
  sed -i "1507s|return 0|return 1|" /opt/openkore/src/Misc.pm
  sed -i "1534s|return 0|return 1|" /opt/openkore/src/Misc.pm
  sed -i "1571s|return !objectIsMovingTowardsPlayer(\$monster);|return 1;|" /opt/openkore/src/Misc.pm
  sed -i "1583s|return 0|return 1|" /opt/openkore/src/Misc.pm
fi

# configure defaults

cp /opt/openkore/control/custom/mon_control.txt /opt/openkore/control/mon_control.txt

# add bot specific config
case ${OK_CLASS} in
  mage)
    echo "Using config_mage.txt..."
    cp /opt/openkore/control/custom/config_mage.txt /opt/openkore/control/config.txt
    ;;
  knight)
    echo "Using config_knight.txt..."
    cp /opt/openkore/control/custom/config_knight.txt /opt/openkore/control/config.txt
    ;;
  archer)
    echo "Using config_archer.txt..."
    cp /opt/openkore/control/custom/config_archer.txt /opt/openkore/control/config.txt
    ;;
  priest)
    echo "Using config_priest.txt..."
    cp /opt/openkore/control/custom/config_priest.txt /opt/openkore/control/config.txt
    ;;
  *)
    echo "Using config_default.txt..."
    cp /opt/openkore/control/custom/config_default.txt /opt/openkore/control/config.txt
    ;;
esac

sed -i "s|^username$|username ${OK_USERNAME}|g" /opt/openkore/control/config.txt
sed -i "s|^master$|master ${OK_SERVER}|g" /opt/openkore/control/config.txt
sed -i "s|^server$|server 0|g" /opt/openkore/control/config.txt
sed -i "s|^password$|password ${OK_PWD}|g" /opt/openkore/control/config.txt
sed -i "s|^char$|char ${OK_CHAR}|g" /opt/openkore/control/config.txt

# follow user
if ! [ -z "${OK_FOLLOW_USERNAME}" ]; then
  sed -i "s|^followTarget$|followTarget ${OK_FOLLOW_USERNAME}|g" /opt/openkore/control/config.txt
fi

sed -i "s|^autoResponse 0$|autoResponse 1|g" /opt/openkore/control/config.txt
sed -i "s|^autoResponseOnHeal 0$|autoResponseOnHeal 1|g" /opt/openkore/control/config.txt
sed -i "s|^route_randomWalk_inTown 0$|route_randomWalk_inTown 1|g" /opt/openkore/control/config.txt
sed -i "s|^partyAuto 1$|partyAuto 2|g" /opt/openkore/control/config.txt
sed -i "s|^follow 0$|follow 1|g" /opt/openkore/control/config.txt
sed -i "s|^followSitAuto 0$|followSitAuto 1|g" /opt/openkore/control/config.txt
sed -i "s|^attackAuto_inLockOnly 1$|attackAuto_inLockOnly 0|g" /opt/openkore/control/config.txt

sed -i "s|^lockMap$|lockMap ${CHAR_MAP}|g" /opt/openkore/control/config.txt

exec "$@"
