FROM alpine:3.7
LABEL maintainer="Christian Bargmann <chris@cbrgm.net>"

ENV PACKET_OBFUSCATION=0
ENV PACKETVER=20180620
ENV GITHUB_URL="https://github.com/rathena/rathena.git"

RUN mkdir -p /opt/rAthena \
    && apk update \
    && apk add --no-cache git make gcc g++ mariadb-dev mariadb-client-libs zlib-dev pcre-dev libressl-dev pcre libstdc++ nano dos2unix mysql-client bind-tools linux-headers \
    && git clone ${GITHUB_URL} /opt/rAthena \
    && cd /opt/rAthena \
    && if [ ${PACKET_OBFUSCATION} -ne 1 ]; then sed -i "s|#define PACKET_OBFUSCATION|//#define PACKET_OBFUSCATION|g" /opt/rAthena/src/config/packets.hpp; fi \
    && if [ ${PACKET_OBFUSCATION} -ne 1 ]; then sed -i "s|#define PACKET_OBFUSCATION_WARN|//#define PACKET_OBFUSCATION_WARN|g" /opt/rAthena/src/config/packets.hpp; fi \
    && ./configure --enable-packetver=${PACKETVER} \
    && make clean \
    && make server \
    && chmod a+x login-server && chmod a+x char-server && chmod a+x map-server \
    && apk del git make gcc g++ mariadb-dev zlib-dev pcre-dev libressl-dev


COPY scripts/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 6900/tcp 6121/tcp 5121/tcp

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR /opt/rAthena
CMD ["/opt/rAthena/athena-start", "watch"]
