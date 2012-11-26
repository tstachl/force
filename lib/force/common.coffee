
request = require 'request'
semver = require 'semver'
force = require '../force'

exports.checkVersion = (callback) ->
  request uri: 'http://registry.npmjs.org/force/latest', timeout: 400, (err, res, body) ->
    try
      pkg = JSON.parse body
      
      if semver.gt pkg.version, force.version
        force.log.warn "A newer version of #{'force'.magenta} is available. Please update immediately!"
        force.log.help "To install the latest #{'force'.magenta} type `npm install force -g`"
        force.log.warn "To #{'continue'.bold} without an update #{'type'.cyan} #{'\'yes\''.magenta}"
        
        force.prompt.confirm "Continue without updating? Bad things might happen (no)", (err, result) ->
          if err then callback() else callback(!result)
        
        return
      
      callback()
    
    catch e
      callback()