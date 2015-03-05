#!/bin/bash
cd `dirname $0`
export NODE_PATH=/home/ubuntu/proj/tools/node-v0.10.33-linux-x64/bin
export NODE_PATH=$NODE_PATH:/home/ubuntu/proj/tools/node-v0.10.33-linux-x64/lib/node_modules
export MONGO_PATH=/home/ubuntu/proj/tools/mongodb-linux-x86_64-2.6.4/bin
export PATH=$MONGO_PATH:$NODE_PATH:$PATH
export NODE_ENV=production

if [ "$1" = restart ]
then
  echo restart..
elif [ "$1" = rollback ]
then
  echo rollback..
  rm -rf dist_online
  cp -r dist_bk dist_online
else
  echo start newly deployed..
  rm -rf dist_bk
  mv dist_online dist_bk
  cp -r dist dist_online
fi

pkill node
nohup /home/ubuntu/proj/tools/node-v0.10.33-linux-x64/bin/forever /home/ubuntu/maui/dist_online/server/app.js&
nohup /home/ubuntu/proj/tools/node-v0.10.33-linux-x64/bin/http-server -p 8111 /data/blockly-games/&
