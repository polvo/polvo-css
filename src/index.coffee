(require 'source-map-support').install
  handleUncaughtExceptions: false

path = require 'path'
fs = require 'fs'
clone = require 'regexp-clone'

module.exports = new class Index

  type: 'style'
  name: 'css'
  output: 'css'

  ext: /\.css$/m
  exts: [ '.css' ]

  partials: on

  has_imports = /^(?:(?!\s*\/\*).?)\@import/gm

  match_all = ///
    ^             # start of line
    (?:           # begin non-capturing group
      (?!         # begin negative look ahead
        \s*/\*    # negating '/*' sequence preceded or not by spaces
      )           # end negative look ahead
      .?          # any single character, optional
    )             # end non-capturing group
    \@import\s*   # capture '@import' directive
    (?:           # begin non-capturing group
      url\s*\(\s* # matches 'url(' start method
    )?            # make the last match optional
    (?:           # begin non-capturing group
      '|"         # matches single / double quotes
    )             # end non-capturing group
    (             # being capturing group
      [^'"]+      # matches anything but single/double quotes (filepath)
    )             # end capturing group
    (?:           # begin non-capturing group
      '|"         # matches single / double quotes
    )             # end non-capturing group
    \s*\)?\s*;   # matches closing parenthesis ')' followed by a semicolon
    ?             # makes last match optional, in case url() are not in use
  ///gm

  is_partial:( filepath )->
    /^_/m.test path.basename filepath

  compile:( filepath, source, debug, error, done )->
    done @render_partials(filepath, source, error), null

  resolve_dependents:( filepath, files )->
    dependents = []

    for each in files
      [has, all] = [clone(has_imports), clone(match_all)]
      continue if not has.test each.raw

      dirpath = path.dirname each.filepath
      name = path.basename each.filepath

      while (match = all.exec each.raw)?
        impor7 = match[1]
        impor7 = impor7.replace(/\.css$/m, '') + '.css'
        impor7 = path.join dirpath, impor7

        if impor7 is filepath
          if not @is_partial name
            dependents.push each
          else
            sub = @resolve_dependents each.filepath, files
            dependents =  dependents.concat sub

    dependents

  render_partials:( filepath, source, error )->
    [has, all] = [clone(has_imports), clone(match_all)]
    return source if not has.test source

    buffer = source
    while (match = all.exec source)?
      full = match[0]
      impor7 = match[1]
      impor7_path = path.join (path.dirname filepath), impor7
      impor7_path = impor7_path.replace(/\.css$/m, '') + '.css'

      if fs.existsSync impor7_path
        partial_content = fs.readFileSync(impor7_path).toString()
        partial_content = @render_partials impor7_path, partial_content, error
      else
        partial_content = ''
        error "file '#{impor7}' do not exist for '#{filepath}'"

      buffer = buffer.replace full, partial_content

    buffer