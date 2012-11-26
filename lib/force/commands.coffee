force = require '../force'
cliUsers = require 'flatiron-cli-users'

force.use require('flatiron-cli-users'),
  before:
    login: (details) ->
  after:
    create: (details) ->

for command in ['available', 'create']
  if cliUsers.commands[command]
    delete force.commands.users[command]
delete force.commands['signup']

force.commands.users.usage = [
  "`force users *` commands allow you to work with new"
  "or existing user accounts"
  ""
  "force users changepassword"
  "force users forgot <username> <shake>"
  "force users login"
  "force users logout"
  "force users whoami"
  ""
  "You will be prompted for additional user information"
  "as required."
]