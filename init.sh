#!/bin/bash
cp -rf /miraigo /mirai/
cp -rf /template /mirai/
if [ -f /mirai/config.json ];then
    touch /mirai/config.json
else
     cp -f /config.json /mirai/
fi
#rm -rf /miraigo
touch /mirai/install.lock

chmod +x /mirai/miraigo
#sed -i "s/\$QQ/$QQ/" /mirai/config.json
#sed -i "s/\$PASSWORD/$PASSWORD/" /mirai/config.json
#sed -i "s/\$TOKEN/$TOKEN/" /mirai/config.json
#sed -i "s,\$POSTURL,$POSTURL,"  /mirai/config.json
#sed -i "s/\$SECRET/$SECRET/" /mirai/config.json
php /sed.php

#/mirai/miraigo
/usr/bin/supervisord -c /etc/supervisord.conf
