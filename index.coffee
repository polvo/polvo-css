(require 'source-map-support').install
  handleUncaughtExceptions: false

module.exports = new class Index

  type: 'style'
  name: 'css'
  output: 'css'

  ext: /\.css$/m
  exts: [ '.css' ]

  compile:( filepath, source, debug, error, done )->
    done source, null