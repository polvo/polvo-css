path = require 'path'
fs = require 'fs'
fsu = require 'fs-util'

should = require('chai').should()
css = require '../../'

fixtures = path.join __dirname, '..', 'fixtures'

paths = 
  base: path.join fixtures, 'base.css'
  _d: path.join fixtures, 'sub', '_d.css'

contents = 
  base: fs.readFileSync(paths.base).toString()
  _d: fs.readFileSync(paths._d).toString()

describe '[polvo-css]', ->
  it 'should render file and its partials, recursively, showing errors properly', ->
    count =  err: 0, out: 0
    error =(msg)->
      reg = /file 'sub\/not\/existent' do not exist for '.+\/fixtures\/_a.css'/
      reg.test msg
      count.err++
    done =( compiled )->
      count.out++
      clean = compiled.replace /[\s\n]/g, ''
      clean.should.equal '.a{}.b{}.c{}.d{}'

    css.compile paths.base, contents.base, null, error, done
    count.out.should.equal 1
    count.err.should.equal 1

  it 'should return all file dependents', ->
    list = []
    for file in fsu.find fixtures, /\.css/
      list.push filepath:file, raw: fs.readFileSync(file).toString()

    dependents = css.resolve_dependents {filepath:paths._d}, list
    dependents.length.should.equal 1
    dependents[0].filepath.should.equal paths.base