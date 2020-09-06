FROM golang:alpine AS builder
#RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates  git

RUN  git clone --depth 1 https://github.com/Mrs4s/go-cqhttp.git /miraigo
#ENV GOPROXY https://goproxy.cn
RUN  cd /miraigo\
#     && go list -json all\
     && go build  -ldflags "-s -w -extldflags '-static'"  -o miraigo

FROM alpine
ENV QQ=""
ENV PASSWORD=""
ENV TOKEN=""
ENV POSTURL=""
ENV SECRET=""
ENV WS_REVERSE_URL=""
ENV WS_REVERSE_API_URL=""
ENV WS_REVERSE_EVENT_URL=""
ENV WS_REVERSE_SERVERS_ENABLE=false
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#ADD mirai /mirai
RUN mkdir /mirai
COPY init.sh /
COPY --from=builder /miraigo/miraigo /
COPY config.json  /
COPY check.php /
COPY sed.php /
WORKDIR /mirai

#RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates && \
     apk add --no-cache curl bash openssl-dev tree tzdata php7-openssl \
     php7 php7-curl php7-json php7-pear php7-phar php7-sqlite3 \
     php7-pecl-protobuf php7-pdo_mysql php7-mysqli php7-ctype \
     php7-pecl-uuid php7-pecl-redis  php7-dev php7-session  \
     php7-fileinfo php7-mbstring php7-pdo php7-pdo_sqlite  php7-zip php7-gd \
     php7-xml php7-iconv php7-pecl-apcu php7-bcmath  php7-pecl-mcrypt php7-xmlwriter \
     expect git supervisor gcc g++ make && \
     cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime\
     && apk del tzdata \
     && chmod +x /init.sh \
     && mkdir -p /var/log/supervisord
HEALTHCHECK --interval=5s --timeout=2s --retries=10 \
  CMD php /check.php || exit 1

COPY supervisord.conf /etc/
COPY supervisor.d /etc/

RUN wget http://pecl.php.net/get/swoole-4.4.14.tgz \
    && printf "no\nyes\nyes\nno" | pecl install swoole-4.4.14.tgz \
    && echo "extension=swoole.so" > /etc/php7/conf.d/50-swoole.ini \
    && rm -rf swoole-4.4.14.tgz

CMD ["/init.sh"]
