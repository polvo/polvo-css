# Polvo CSS

With this plugin, Polvo can handle CSS source files.

[![Stories in Ready](https://badge.waffle.io/polvo/polvo-css.png)](https://waffle.io/polvo/polvo-css)

[![Build Status](https://secure.travis-ci.org/polvo/polvo-css.png)](http://travis-ci.org/polvo/polvo-css) [![Coverage Status](https://coveralls.io/repos/polvo/polvo-css/badge.png)](https://coveralls.io/r/polvo/polvo-css)

[![Dependency Status](https://gemnasium.com/polvo/polvo-css.png)](https://gemnasium.com/polvo/polvo-css) [![NPM version](https://badge.fury.io/js/polvo-css.png)](http://badge.fury.io/js/polvo-css)

# Installation

You won't need to install it since it comes built in in Polvo.

Enjoy.

# Instructions

Just put your `.css` files in your `input` or `aliased` **dirs** and it will be
ready for use.

# Partials

This plugin comes with partials support as well.  It is, you can split big file
into multiple pieces and tie it together where you prefer, by importing them.

Every file starting with `_` won't be compiled alone. Instead, if some other
file that doesn't start with `_` imports it, it will be compiled within it.

 1. The `@import` tag syntax is based on the W3C [specification](http://www.w3.org/TR/CSS2/cascade.html#at-import).

 1. However it's behavior is different, much like you'll find in languages like
 [Stylus](https://github.com/learnboost/stylus).

 1. The `@import` call will be replaced with the contents of the `.css` it's
 pointing to. Do not forget this, your `@import` directives will be dropped and
 replaced with another file's contents.

 1. There's no way for keeping `@import` directives in the output file.

To include a partial in your `css`, just:

 1. Name your patial accordingly so it starts with `_`
 1. Include it in any of your `css` files by using the syntax

````css
@import 'mypartial';
@import url('mypartial');
````

You decide what mode you prefer.

# Final notes

- Partials are referenced relatively
- You can include `partials` inside `partials` recursively, but do not forget to
`@import` the top-level `partial` in a `non-partial`, otherwise the whole
partials-chain will be left out.