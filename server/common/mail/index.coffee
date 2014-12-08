jade = require 'jade'
fs = require('fs')
querystring = require("querystring");
nodemailer = require('nodemailer');
scTransport = require('./sendcloud-transport');

pwdResetTpl = require('fs').readFileSync(__dirname + '/views/pwdReset.jade', 'utf8')
pwdResetFn = jade.compile pwdResetTpl, pretty: true

pwdActivationTpl = require('fs').readFileSync(__dirname + '/views/pwdActivation.jade', 'utf8')
pwdActivationFn = jade.compile pwdActivationTpl, pretty: true

config = require '../../config/environment'
host = config.host
emailConfig = config.emailConfig
transporter = nodemailer.createTransport(scTransport(emailConfig))


sendMail = (receiverEmail, htmlOutput, subject) ->
  mailOptions =
    from: "学之方 <noreply@cloud3edu.cn>"
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

  sendMail receiverEmail, htmlOutput, "学之方 -- 密码找回邮件"


exports.sendActivationMail = (receiverEmail, activationCode) ->
  activationLinkQS = querystring.stringify
    email: receiverEmail
    activation_code: activationCode

  activation_link = host+'/api/users/completeActivation?'+ activationLinkQS
  locals =
    email: receiverEmail
    activation_link: activation_link

  htmlOutput = pwdActivationFn locals

  sendMail receiverEmail, htmlOutput, "学之方 -- 账户激活邮件"

