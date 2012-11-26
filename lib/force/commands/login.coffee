force = require '../../force'


login = (callback) ->
  console.log force.argv


force.plugins.cli.argv.call force,
  username:
    alias: 'u'
    description: 'username for the organization'
    string: yes
  password:
    alias: 'p'
    description: 'password for the organization'
    string: yes
  endpoint:
    alias: 'e'
    description: 'endpoint to use "login.salesforce.com"'
    string: yes

login.usage = [
  "`force login` command allows you to authorize"
  "and store a session with force.com."
  ""
  "force login [options]"
]

module.exports = login

