jade = require 'jade'
fs = require('fs')
querystring = require("querystring");
nodemailer = require('nodemailer');
scTransport = require('./sendcloud-transport');

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

config = require '../../config/environment'
host = config.host
emailConfig = config.emailConfig
transporter = nodemailer.createTransport(scTransport(emailConfig))


sendMail = (receiverEmail, htmlOutput, subject) ->
  mailOptions =
    from: "杨梅客 <noreply@cloud3edu.cn>"
    to: receiverEmail
    subject: subject
    html: htmlOutput

  transporter.sendMail mailOptions, (error, info) ->
    console.log(error || 'Message sent: ' + info)


exports.sendPwdResetMail = (receiverName, receiverEmail, resetLink) ->
  locals =
    username: receiverName
    resetLink: resetLink

  htmlOutput = pwdResetFn locals

  sendMail receiverEmail, htmlOutput, "杨梅客 -- 密码找回邮件"


