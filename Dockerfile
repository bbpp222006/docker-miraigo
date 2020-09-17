FROM golang:alpine AS builder
#RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates  git

RUN  git clone --depth 1 https://github.com/scjtqs/go-cqhttp.git /miraigo
RUN go get -u github.com/gobuffalo/packr/v2/packr2
#ENV GOPROXY https://goproxy.cn
RUN  cd /miraigo\
#     && go list -json all\
     && CGO_ENABLED=0 packr2 build  -o miraigo

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
#COPY --from=builder /miraigo/template/ /template/
COPY config.json  /
COPY check.php /
COPY sed.php /
WORKDIR /mirai

#RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates && \
     apk add --no-cache curl bash tree tzdata php7-openssl php7 php7-curl php7-json expect git supervisor && \
     cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime\
     && apk del tzdata \
     && chmod +x /init.sh \
     && mkdir -p /var/log/supervisor
HEALTHCHECK --interval=5s --timeout=2s --retries=10 \
  CMD php /check.php || exit 1

COPY supervisord.conf /etc/
ADD supervisor.d/ /etc/supervisor.d/

CMD ["/init.sh"]
