colors    = require 'colors'
flatiron  = require 'flatiron'
path      = require 'path'
logger    = require './force/logger'

force = module.exports = flatiron.app

# Configure force to use pkginfo to expose version
require('pkginfo') module, 'name', 'version', 'author'

force.use flatiron.plugins.cli,
  version: yes
  source: path.join __dirname, 'force', 'commands'
  usage: require './force/usage'
  argv:
    version:
      alias: 'v'
      description: 'print force version and exit'
      string: yes
    raw:
      alias: 'R'
      description: 'force will only output raw JSON'
      boolean: yes


force.use flatiron.plugins.log,
  transports: [
    new logger level: 'debug', raw: force.argv.raw
  ]

unless force.log.help
  logger = force.log.get 'default'
  logger.cli().extend force.log

require './force/config'
require './force/commands'

force.started   = no
force.common    = require './force/common'

force.api         = {}
#force.api.Client  = require('metaforce').Client

force.welcome = ->
  username = force.config.get('username') or ''
  force.log.info "Welcome to force #{username}"
  force.log.info "force v#{force.version}, node #{process.version}"
  force.log.info ""

force.start = (callback) ->
  useColors = typeof force.argv.colors == 'undefined' or force.argv.colors
  useColors or (colors.mode = 'none')
  
  if force.argv._[0] == 'whoami'
    return force.log.data 'whoami', username: force.config.get('username') or ''
  
  force.common.checkVersion (err) ->
    return callback() if err
    
    force.init (err) ->
      if err
        force.welcome()
        callback err
        return force.showError force.argv._.join(' '), err
      
      if not force.config.get 'colors' or not useColors
        colors.mode = 'none'
        force.log.get('default').stripColors = yes
        force.log.get('default').transports.console.colorize = no
      
      force.welcome()
      
      username = force.config.get 'username'
      if not username and ~force.config.get('requiresAuth').indexOf force.argv._[0]
        unless force.argv.raw
          return force.commands.users.login (err) ->
            if err
              callback err
              return force.showError force.argv._.join(' '), err
          
          username = force.config.get 'username'
          force.log.info "Successfully configured user #{username}"
          return force.exec force.argv._, callback
        else
          return force.log.error "This method requires authentication. Please login to proceed."
      
      return force.exec force.argv_, callback
      
force.exec = (command = [], callback) ->
  execCommand = (err) ->
    return callback err if err
    
    force.log.info "Executing command #{command.join(' ')}"
    force.router.dispatch 'on', command.join(' '), force.log, (err, shallow) ->
      if err
        callback err
        return force.showError command.join(' '), err, shallow, force.argv.raw
      
      callback()
  
  unless force.started then force.setup execCommand else execCommand()

force.setup = (callback) ->
  return callback() if force.started is yes
  
  ## do some setup stuff
  
  force.started = yes
  callback()

force.showError = (command, err, shallow, skip) ->
  unless skip
    force.log.error "Error running command `#{command}`"
    force.log.error err.message if err.message
