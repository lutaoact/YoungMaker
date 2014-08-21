//var config = require('config');
var log4js = require('log4js');

log4js.configure({
    appenders: [
        { type: 'console' },
        { type: 'file', filename: config.logger.path, category: '[ALOHA]' },
        {
            type        : 'file' ,
            filename    : '/data/log/dmp.log',
            layout      : {
                type    : 'pattern',
                pattern : "%m%n",
            },
            category    : 'DMP',
        }
    ]
});

var logger = log4js.getLogger('[ALOHA]');
logger.setLevel(config.logger.level);

exports.logger = logger;
