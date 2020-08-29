#!/bin/bash
if [ -f /mirai/install.lock ];then
    echo 'mirai installed'
    touch /mirai/install.lock
else
    mv -n /miraigo /mirai/
    mv -n /config.json /mirai/
    rm -rf /miraigo
    touch /mirai/install.lock
fi

chmod +x /mirai/miraigo
sed -i "s/\$QQ/$QQ/" /mirai/config.json
sed -i "s/\$PASSWORD/$PASSWORD/" /mirai/config.json
sed -i "s/\$TOKEN/$TOKEN/" /mirai/config.json
sed -i "s,\$POSTURL,$POSTURL,"  /mirai/config.json
sed -i "s/\$SECRET/$SECRET/" /mirai/config.json
php /sed.php

/mirai/miraigo
