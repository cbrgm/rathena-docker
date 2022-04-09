docker run -it --rm --name openkore-userK694aba-knight \
  -e OK_SERVER=rAthena \
  -e OK_USERNAME=cbrgm \
  -e OK_PWD=asdasd \
  -e OK_CHAR=0 \
  -e CHAR_MAP=prontera \
  -e OK_KILLSTEAL=1 \
  -e OK_CLASS=mage \
  -e OK_FOLLOW_USERNAME=Kathrine \
  cbrgm/openkore:latest

docker run -itd --name openkore-userR707thh-mage \
  -e OK_SERVER=fRO \
  -e OK_USERNAME=userR707thh \
  -e OK_PWD=0520b7 \
  -e OK_CHAR=0 \
  -e CHAR_MAP=prontera \
  -e OK_KILLSTEAL=1 \
  -e OK_CLASS=mage \
  -e OK_FOLLOW_USERNAME=Cynthek \
  cbrgm/openkore:latest

docker run -itd --name openkore-userU709smr-archer \
  -e OK_SERVER=fRO \
  -e OK_USERNAME=userU709smr \
  -e OK_PWD=b434e9 \
  -e OK_CHAR=0 \
  -e CHAR_MAP=pay_dun01 \
  -e OK_KILLSTEAL=1 \
  -e OK_CLASS=archer \
  -e OK_FOLLOW_USERNAME=Cynthek \
  cbrgm/openkore:latest

docker run -itd --name openkore-userR817rij-priest \
  -e OK_SERVER=fRO \
  -e OK_USERNAME=userR817rij \
  -e OK_PWD=f8ba3e \
  -e OK_CHAR=0 \
  -e CHAR_MAP=pay_dun01 \
  -e OK_KILLSTEAL=1 \
  -e OK_CLASS=priest \
  -e OK_FOLLOW_USERNAME=Cynthek \
  cbrgm/openkore:latest

docker run -itd --name openkore-userS710eyo-main \
  -e OK_SERVER=fRO \
  -e OK_USERNAME=userS710eyo \
  -e OK_PWD=mynewpassword \
  -e OK_CHAR=0 \
  -e CHAR_MAP=pay_dun01 \
  -e OK_KILLSTEAL=1 \
  -e OK_CLASS=knight \
  cbrgm/openkore:latest
