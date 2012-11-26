colors    = require 'colors'
common    = require 'winston/lib/winston/common'
config    = require 'winston/lib/winston/config'
cycle     = require 'cycle'
Transport = require('winston/lib/winston/transports/transport').Transport

config.addColors config.cli.colors

colorize = (level, message) ->
  return message unless config.allColors[level]
  
  if config.allColors[level] instanceof Array
    for color in config.allColors[level]
      message = message[color]
  
  else if config.allColors[level].match /\s/
    colorArr = config.allColors[level].split /\s+/
    for color in colorArr
      message = message[color]
  
  else
    message = message[config.allColors[level]]
  
  message

module.exports = class ForceConsole extends Transport
  name: 'console'
  stack: []
  
  constructor: (options) ->
    super options
    options ?= {}
    
    @json         = options.json          ? no
    @colorize     = options.colorize      ? no
    @prettyPrint  = options.prettyPrint   ? no
    @timestamp    = options.timestamp     ? no
    
    if @json
      @stringify  = options.stringify     ? (obj) ->
        JSON.stringify obj, null, 2
    
    process.on 'exit', =>
      @exit()
  
  data: (obj, callback) ->
    if @raw
      @_data = obj
    else
      @log('data', obj, null, callback)
  
  log: (level, msg, meta, callback) ->
    return callback null, yes if @silent
        
    if @raw or @json
      if level == 'data' and meta
        @_data = meta
      @stack.push JSON.parse common.log
        colorize: @colorize
        json: @json
        level: level
        message: msg
        meta: meta
        stringify: @stringify
        timestamp: @timestamp
        prettyPrint: @prettyPrint
        raw: @raw
    
    else
      output = if @colorize then colorize level, msg else msg
      if level == 'data' and meta
        output += "\n#{JSON.stringify(meta, null, 2)}"
      
      if level == 'error' or level == 'debug'
        process.stderr.write "#{output}\n"
      else
        process.stdout.write "#{output}\n"
    
    @emit 'logged'
    callback null, yes

  exit: ->
    if @stack.length > 0
      console.log JSON.stringify
        success: if @stack.filter((item) -> item.level == 'error').length > 0 then no else yes
        data: @_data
        log: @stack
      , null, 2
      