FROM alpine:latest

LABEL title="openkore" \
  maintainer="Christian Bargmann"

RUN mkdir -p /opt/openkore \
  && apk update \
  && apk add --no-cache git build-base g++ perl perl-dev perl-time-hires perl-compress-raw-zlib readline readline-dev ncurses-libs ncurses-terminfo-base ncurses-dev python2 curl curl-dev nano dos2unix mysql-client bind-tools file \
  && git clone https://github.com/openkore/openkore.git /opt/openkore \
  && ln -s /usr/lib/libncurses.so /usr/lib/libtermcap.so \
  && ln -s /usr/lib/libncurses.a /usr/lib/libtermcap.a \
  && cd /opt/openkore/ \
  && make

RUN iconv -f iso-8859-1 -t us-ascii /opt/openkore/tables/headgears.txt > /opt/openkore/tables/tmp.txt \
  && rm /opt/openkore/tables/headgears.txt \
  && mv /opt/openkore/tables/tmp.txt /opt/openkore/tables/headgears.txt

RUN iconv -f iso-8859-1 -t us-ascii /opt/openkore/tables/translated/kRO_english/items.txt > /opt/openkore/tables/tmp.txt \
  && rm /opt/openkore/tables/translated/kRO_english/items.txt \
  && mv /opt/openkore/tables/tmp.txt /opt/openkore/tables/items.txt

RUN mv /opt/openkore/fields/EP14.1/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP14.3/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP15.1/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP15.2/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP16.1/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP16.2/*.gz /opt/openkore/fields \
  && mv /opt/openkore/fields/EP17.1/*.gz /opt/openkore/fields

COPY ./servers.txt /opt/openkore/tables/
COPY ./config/* /opt/openkore/control/custom/

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR /opt/openkore
CMD ["/opt/openkore/openkore.pl"]
