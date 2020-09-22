# how to use
9999端口 为 webui管理端口

## for docker run
```
docker run --privileged  --tty=true \
-p 5700:5700 \
-p 6700:6700 \
-p 9999:9999 \
-v  `pwd`/mirai-data:/mirai \
-e QQ="123456789" \
-e PASSWORD="password" \
-e TOKEN="token" \
-e POSTURL="https://www.qq.com" \
-e SECRET="secret" --name miraigo-cqhttp  scjtqs/miraigo
```


## for docker-compose
vim docker-compose.yaml
放入下面的代码

```
version: '3'
#miraigo 的 cqhttp api 版本，linux环境的docker版本。
services:
  mirai-cqhttp:
    container_name: miraigo-cqhttp
    image: scjtqs/miraigo
    restart: always
    privileged: true
    tty: true
    ports:
      - 5700:5700
      - 6700:6700
      - 9999:9999
    volumes:
      - ./mirai-data:/mirai
    environment:
       QQ: '123456789'
       PASSWORD: '123456789'
       TOKEN: 'token'
       POSTURL: 'https://www.qq.com'
       SECRET: 'secret'
```

`docker-compose up` 或者 `docker-compose up -d`（后台运行）

### 添加阿里云国内镜像
docker pull registry.cn-hangzhou.aliyuncs.com/scjtqs/miraigo:latest