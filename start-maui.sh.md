#!/bin/bash
cd `dirname $0`
export NODE_PATH=/home/ubuntu/proj/tools/node-v0.10.33-linux-x64/bin
export NODE_PATH=$NODE_PATH:/home/ubuntu/proj/tools/node-v0.10.33-linux-x64/lib/node_modules
export MONGO_PATH=/home/ubuntu/proj/tools/mongodb-linux-x86_64-2.6.4/bin
export PATH=$MONGO_PATH:$NODE_PATH:$PATH
export NODE_ENV=production
nohup /home/ubuntu/proj/tools/node-v0.10.33-linux-x64/bin/forever /home/ubuntu/maui/dist/server/app.js&
