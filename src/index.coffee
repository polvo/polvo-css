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

  resolve_dependents:( file, files )->
    dependents = []

    for each in files

      has = clone has_imports
      all = clone match_all

      continue if not has.test each.raw

      dirpath = path.dirname each.filepath
      name = path.basename each.filepath

      while (match = all.exec each.raw)?
        include = match[1]
        include = include.replace(/\.css$/m, '') + '.css'
        include = path.join dirpath, include

        if include is file.filepath
          if not @is_partial name
            dependents.push each
          else
            dependents = dependents.concat @resolve_dependents each, files

    dependents

  render_partials:( filepath, source, error )->

    has = clone has_imports
    all = clone match_all

    return source if not has.test source

    buffer = source
    while (match = all.exec source)?
      full = match[0]
      include = match[1]
      include_path = path.join (path.dirname filepath), include
      include_path = include_path.replace(/\.css$/m, '') + '.css'

      if fs.existsSync include_path
        partial_content = fs.readFileSync(include_path).toString()
        partial_content = @render_partials include_path, partial_content, error
      else
        partial_content = ''
        error "file '#{include}' do not exist for '#{filepath}'"

      buffer = buffer.replace full, partial_content

    buffer