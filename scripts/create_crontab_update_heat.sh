SCRIPTS_PATH=$(pwd)
MONGO_PATH=$(which mongo)
if [ "$NODE_ENV" = 'production' ]; then
  command="$MONGO_PATH 10.80.44.45/maui $SCRIPTS_PATH/crontab_update_heat.js 2>&1 >> /data/log/crontab.log"
else
  command="$MONGO_PATH maui-dev $SCRIPTS_PATH/crontab_update_heat.js 2>&1 >> /data/log/crontab.log"
fi

echo "3,13,23,33,43,53 * * * * $command"
