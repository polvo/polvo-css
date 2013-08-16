(require 'source-map-support').install
  handleUncaughtExceptions: false

module.exports = new class Index

  polvo: true

  type: 'style'
  name: 'css'
  output: 'css'

  ext: /\.css$/m
  exts: [ '.css' ]

  compile:( filepath, source, debug, done )->
    done source, null