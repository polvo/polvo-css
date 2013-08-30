// Generated by CoffeeScript 1.6.3
var Index, fs, path;

(require('source-map-support')).install({
  handleUncaughtExceptions: false
});

path = require('path');

fs = require('fs');

module.exports = new (Index = (function() {
  var has_imports, match_all;

  function Index() {}

  Index.prototype.type = 'style';

  Index.prototype.name = 'css';

  Index.prototype.output = 'css';

  Index.prototype.ext = /\.css$/m;

  Index.prototype.exts = ['.css'];

  Index.prototype.partials = true;

  has_imports = /^(?:(?!\s*\/\*).?)\@import/gm;

  match_all = /^(?:(?!\s*\/\*).?)\@import\s*(?:url\s*\(\s*)?(?:'|")([^'"]+)(?:'|")\s*\)?\s*;?/gm;

  Index.prototype.is_partial = function(filepath) {
    return /^_/m.test(path.basename(filepath));
  };

  Index.prototype.compile = function(filepath, source, debug, error, done) {
    return done(this.render_partials(filepath, source, error), null);
  };

  Index.prototype.resolve_dependents = function(file, files) {
    var dependents, dirpath, each, include, match, name, _i, _len;
    dependents = [];
    for (_i = 0, _len = files.length; _i < _len; _i++) {
      each = files[_i];
      has_imports.lastIndex = 0;
      if (!has_imports.test(each.raw)) {
        continue;
      }
      dirpath = path.dirname(each.filepath);
      name = path.basename(each.filepath);
      match_all.lastIndex = 0;
      while ((match = match_all.exec(each.raw)) != null) {
        include = match[1];
        include = include.replace(/\.css$/m, '') + '.css';
        include = path.join(dirpath, include);
        if (include === file.filepath) {
          if (!this.is_partial(name)) {
            dependents.push(each);
          } else {
            dependents = dependents.concat(this.resolve_dependents(each, files));
          }
        }
      }
    }
    return dependents;
  };

  Index.prototype.render_partials = function(filepath, source, error) {
    var full, include, include_contents, include_path, match;
    has_imports.lastIndex = 0;
    if (!has_imports.test(source)) {
      return source;
    }
    match_all.lastIndex = 0;
    while ((match = match_all.exec(source))) {
      full = match[0];
      include = match[1];
      include_path = path.join(path.dirname(filepath), include);
      include_path = include_path.replace(/\.css$/m, '') + '.css';
      if (fs.existsSync(include_path)) {
        include_contents = fs.readFileSync(include_path).toString();
      } else {
        include_contents = '';
        error("file '" + include + "' do not exist");
      }
      source = source.replace(full, include_contents);
    }
    return source;
  };

  return Index;

})());
