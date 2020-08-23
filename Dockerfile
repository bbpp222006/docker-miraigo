FROM golang:alpine AS builder
RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates  git

RUN  git clone https://gitee.com/scjtqs/go-cqhttp-plus.git /miraigo

RUN  cd /miraigo\
#     && go list -json all\
     && go build  -ldflags "-s -w -extldflags '-static'" -o miraigo

FROM alpine:3.12
ENV QQ=""
ENV PASSWORD=""
ENV TOKEN=""
ENV POSTURL=""
ENV SECRET=""
ENV ENV="nornal"
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

#ADD mirai /mirai
RUN mkdir /mirai
COPY init.sh /
COPY --from=builder /miraigo/miraigo /
COPY --from=builder /miraigo/config.json /
COPY check.php /
WORKDIR /mirai

RUN  sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

RUN  apk add --no-cache ca-certificates && \
     apk add --no-cache curl bash tree tzdata php7-openssl php7 php7-curl php7-json expect git && \
     cp -rf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime\
     && apk del tzdata \
     && chmod +x /init.sh
HEALTHCHECK --interval=5s --timeout=2s --retries=10 \
  CMD php /check.php || exit 1

CMD ["/init.sh"]
