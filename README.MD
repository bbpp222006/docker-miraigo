# how to use
## for docker run
```
docker run --privileged  --tty=true \
-p 5700:5700 \
-p 6700:6700 \
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
