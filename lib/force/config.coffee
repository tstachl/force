colors = require 'colors'
path   = require 'path'
fs     = require 'fs'
force  = require '../force'

_load = force.config.load

try
  force.config.file
    file: force.argv.forceconf or '.forceconf'
    dir: process.cwd()
  
catch err
  force.log.error """
  Error parsing #{force.config.stores.file.file.magenta}
  #{err.message}
  
  This is most likely not an error in force.
  Please check the .forceconf file and try again.
  """
  process.exit 1

defaults =
  endpoint: 'login.salesforce.com'
  environment: 'production'
  namespace: ''
  apiVersion: 26.0
  timeout: 400
  colors: yes
  root: process.cwd()
  requiresAuth: [
    'compile'
    'exec'
    'test'
    'retrieve'
    'deploy'
    'list'
    'describe'
  ]
  debuggingHeader:
    debugLevel: 'DETAIL'
    categories: [category: 'Apex_code', level: 'DEBUG']
  deployOptions:
    allowMissingFiles: no
    autoUpdatePackage: no
    checkOnly: no
    ignoreWarnings: no
    performRetrieve: no
    purgeOnDelete: no
    rollbackOnError: yes
    runAllTests: no
    singlePackage: no

force.config.defaults defaults

force.use require('flatiron-cli-config'),
  store: 'file'
  restricted: [
    'root'
    'requiresAuth'
    'auth'
    'sessionId'
  ]
  before:
    list: ->
      username = force.config.get 'username'
      configFile = force.config.stores.file.file
      
      display = [
        "Hello#{(if username then ' ' + username else '').green}, here is the #{configFile.grey} file:"
        "To change a property type:"
        "force config set <key> <value>"
      ]
      
      force.log.warn 'No user has been setup in this project\n' unless username
      for line in display
        force.log.help line
      
      yes

force.config.load = (callback) ->
  _load.call force.config, (err, store) ->
    return callback err, yes, yes, yes if err
    
    force.config.set 'userconfig', force.config.stores.file.file
    if store.auth
      auth = store.auth.split ':'
      force.config.clear 'auth'
      force.config.set 'username', auth[0]
      force.config.set 'password', auth[0]
      return force.config.save callback
    
    callback null, store