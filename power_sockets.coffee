#
# Description:
#   Send RF signals to the power sockets 
# 
# Dependencies:
#   None
#
# Configuration:
# HUBOT_ALLOWED_USERS = bart,homer,lisa
#
# Commands:
#   hubot power {device} on/off - Turns on/off the device
#
# Notes:
# 
# Author:
#   Nadir

allowed_users = process.env.HUBOT_ALLOWED_USERS.split ","
not_allowed_gif = 'https://h3-prod.s3.amazonaws.com/assets/02ea51f0-0e18-11e5-a4ce-12771640ddce.gif?v=1'
rf_sender = '/home/pi/smart-house/rfoutlet/codesend' 
devices = 
  'lights': 
    'on': 4461875
    'off': 4461884

sendSignal= (msg, code) ->
  {spawn} = require 'child_process'
  sender = spawn rf_sender, [code]

module.exports = (robot) ->
  # Only allow execution to a whitelisted user list
  robot.listenerMiddleware (context, next, done) ->
    if context.response.message.user.name in allowed_users
      next()
    else
      robot.logger.info "#{context.response.message.user.name} asked me to #{context.response.message.text}"
      context.response.send not_allowed_gif 
      done()
  
  robot.respond /turn on (.*)/i, (msg) ->
    device = msg.match[1]
    if device of devices
      sendSignal(msg, devices[device]['on'])
      msg.send "#{device} turned ON"
    else
      msg.send "You don't own any #{device} dumbass!"
  
  robot.respond /turn off (.*)/i, (msg) ->
    device = msg.match[1]
    if device of devices
      sendSignal(msg, devices[device]['off'])
      msg.send "#{device} turned OFF"
    else
      msg.send "You don't own any #{device} dumbass!"
