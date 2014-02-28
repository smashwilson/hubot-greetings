# Description
#   Customized greetings on a user-by-user basis.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GREETINGS_FFA - If set, any user can set any other user's greeting.
#
# Commands:
#   hubot greet <name> - Test out <name>'s current greeting; can be "me" or "yourself".
#   hubot greet <name> with <message> - Add "message" as a greeting when <name> joins the channel.
#   hubot don't greet <name> with <message> - Remove a message from <name>'s greetings.
#   hubot show <name>'s greetings - Dump all of the greetings for <name> to the channel.
#   hubot forget <name>'s greetings - Clear all of <name>'s greetings.
#
# Author:
#   smashwilson

freeForAll = process.env.HUBOT_GREETINGS_FFA?

GREETING_ROLE = 'greeting czar'

module.exports = (robot) ->

  withGreetings = (username, callback) ->
    greetings = robot.brain.data.greetings ?= {}
    possibilities = greetings[username] or []
    possibilities = callback(possibilities)
    greetings[username] = possibilities

  sendGreeting = (msg, username) ->
    if username is robot.name
      verbiage = { target: 'yourself', owner: 'my' }
    else
      verbiage = { target: 'me', owner: 'your' }
    chosen = "Use '#{robot.name}: greet #{verbiage.target} with' to customize #{verbiage.owner} greeting!"
    withGreetings username, (greetings) ->
      chosen = msg.random greetings if greetings.length > 0
      greetings
    m = chosen.match /^\/me\s+(.*)$/i
    if m
      msg.emote m[1]
    else
      msg.send chosen

  chooseTarget = (msg, match) ->
    if match is 'me' or match is 'my'
      return msg.message.user.name
    if match is 'yourself' or match is 'your'
      return robot.name
    # Set as some user, whether in the room or not
    return match

  verifyPermission = (msg, target) ->
    return true if freeForAll or msg.message.user.name is target
    if robot.auth.hasRole(msg.message.user, GREETING_ROLE)
      true
    else
      msg.reply "I can't do that, you're not a #{GREETING_ROLE}!"
      msg.reply "Ask your admin to run '#{robot.name}: #{msg.message.user.name} has #{GREETING_ROLE} role' so you can."
      false

  robot.respond /greet (\S+) with (.+)/i, (msg) ->
    target = chooseTarget msg, msg.match[1]
    return unless verifyPermission msg, target

    greeting = msg.match[2]
    withGreetings target, (greetings) ->
      greetings.push greeting
      greetings

    whom = msg.match[1]
    if msg.match[1] is 'me'
      whom = 'you'
    if msg.match[1] is 'yourself'
      whom = 'myself'

    msg.reply "I'll greet #{whom} with '#{greeting}'."

  robot.respond /greet (\S+)$/i, (msg) ->
    target = chooseTarget msg, msg.match[1]
    sendGreeting msg, target

  robot.respond /don\'t greet (\S+) with (.+)/i, (msg) ->
    target = chooseTarget msg, msg.match[1]
    return unless verifyPermission msg, target

    greeting = msg.match[2]
    found = false
    withGreetings target, (greetings) ->
      found = greetings.indexOf(greeting) isnt -1
      (g for g in greetings or [] when g != greeting)
    if found
      msg.reply "Greeting '#{greeting}' is totally forgotten."
    else
      msg.reply "I wasn't going to!"

  robot.respond /show (\S+)('s)? greetings$/i, (msg) ->
    target = chooseTarget msg, msg.match[1]
    withGreetings target, (greetings) ->
      msg.reply(g) for g in greetings
      msg.reply "I don't know how to greet #{target}!" if greetings.length is 0
      greetings

  robot.respond /forget (\S+)('s)? greetings$/i, (msg) ->
    target = chooseTarget msg, msg.match[1]
    return unless verifyPermission msg, target

    withGreetings target, (greetings) ->
      msg.reply "Forgetting #{greetings.length} greetings."
      []

  robot.enter (msg) ->
    sendGreeting msg, msg.message.user.name
