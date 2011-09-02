# Rib

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/rib)
* [rubygems](http://rubygems.org/gems/rib)
* [rdoc](http://rdoc.info/github/godfat/rib)

## DESCRIPTION:

Ruby-Interactive-ruBy -- Yet another interactive Ruby shell

Rib is based on the design of [ripl][] and the work of [ripl-rc][], some of
the features are also inspired by [pry][]. The aim of Rib is to be fully
featured and yet very easy to opt-out or opt-in other features. It shall
be simple, lightweight and modular so that everyone could customize Rib.

[ripl]: https://github.com/cldwalker/ripl
[ripl-rc]: https://github.com/godfat/ripl-rc
[pry]: https://github.com/pry/pry

## REQUIREMENTS:

* Tested with MRI (official CRuby) 1.8.7, 1.9.2, 1.9.3, Rubinius and JRuby
* All gem dependencies are optional, but it's highly recommended to use
  Rib with [bond][] for tab completion.

[bond]: https://github.com/cldwalker/bond

## INSTALLATION:

    gem install rib

## SYNOPSIS:

![Screenshot](https://github.com/godfat/rib/raw/master/screenshot.png)

### As an interactive shell

As IRB (reads `~/.rib/config.rb` writes `~/.rib/history.rb`)

    rib

As Rails console

    rib rails

You could also run in production and pass arguments normally as you'd do in
`rails console` or `./script/console`

    rib rails production --sandbox --debugger

Note: You might need to add ruby-debug or ruby-debug19 to your Gemfile if
you're passing --debugger and using bundler together.

As Ramaze console

    rib ramaze

As a console for whichever the app in the current path
it should be (for now, it's either Rails or Ramaze)

    rib auto

If you're trying to use `rib auto` for a Rails app, you could also pass
arguments as if you were using `rib rails`. `rib auto` is merely passing
arguments.

    rib auto production --sandbox --debugger

As a fully featured interactive Ruby shell (as ripl-rc)

    rib all

As a fully featured app console (yes, some commands could be used together)

    rib all auto # or `rib auto all`, the order doesn't really matter

You can customize Rib's behaviour by setting a config file located at
`~/.rib/config.rb` or `~/.config/rib/config.rb`, or `$RIB_HOME/config.rb` by
setting `$RIB_HOME` environment variable. Since it's merely a Ruby script
which would be loaded into memory before launching Rib shell session, You can
put any customization or monkey patch there. Personally, I use all plugins
provided by Rib.

<https://github.com/godfat/dev-tool/blob/master/.config/rib/config.rb>

As you can see, putting `require 'rib/all'` into config file is exactly the
same as running `rib all` without a config file. What `rib all` would do is
merely require the file, and that file is also merely requiring all plugins,
but without **extra plugins**, which you should enable them one by one. This
is because most extra plugins are depending on other gems, or hard to work
with other plugins, or having strong personal tastes, so you won't want to
enable them all. Suppose you only want to use the core plugins and color
plugin, you'll put this into your config file:

    require 'rib/core'
    require 'rib/more/color'

You can also write your plugins there. Here's another example:

    require 'rib/core'
    require 'pp'
    Rib.config[:prompt] = '$ '

    module RibPP
      Rib::Shell.send(:include, self)

      def format_result result
        result_prompt + result.pretty_inspect
      end
    end

So that we override the original format_result to pretty_inspect the result.
You can also build your own gem and then simply require it in your config
file. To see a list of overridable API, please read [api.rb][]

Currently, there are two **extra plugins**.

* `require 'rib/extra/autoindent'` This plugin is depending on:

  1. [readline_buffer][]
  2. readline plugin
  3. multiline plugin

* `require 'rib/extra/hirb'` This plugin is depending on:

  1. [hirb][]

[api.rb]: https://github.com/godfat/rib/blob/master/lib/rib/api.rb
[readline_buffer]: https://github.com/godfat/readline_buffer
[hirb]: https://github.com/cldwalker/hirb

#### Basic configuration

Rib.config                 | Functionality
-------------------------- | -------------------------------------------------
ENV['RIB_HOME']            | Specify where Rib should store config and history
Rib.config[:config]        | The path where config should be located
Rib.config[:name]          | The name of this shell
Rib.config[:result_prompt] | Default is "=>"
Rib.config[:prompt]        | Default is ">>"
Rib.config[:binding]       | Context, default: TOPLEVEL_BINDING
Rib.config[:exit]          | Commands to exit, default [nil, 'exit', 'quit']

#### Plugin specific configuration

Rib.config                     | Functionality
------------------------------ | ---------------------------------------------
Rib.config[:completion]        | Completion: Bond config
Rib.config[:history_file]      | Default is "~/.rib/config/history.rb"
Rib.config[:history_size]      | Default is 500
Rib.config[:color]             | A hash of Class => :color mapping
Rib.config[:autoindent_spaces] | How to indent? Default is two spaces: '  '

### As a debugging/interacting tool

Rib could be used as a kind of debugging tool which you can set break point
in the source program.

    require 'rib/config' # This would load your Rib config
    require 'rib/more/anchor'
                         # If you enabled anchor in config, then needed not
    Rib.anchor binding   # This would give you an interactive shell
                         # when your program has been executed here.
    Rib.anchor 123       # You can also anchor on an object.

But this might be called in a loop, you might only want to
enter the shell under certain circumstance, then you'll do:

    require 'rib/debug'
    Rib.enable_anchor do
      # Only `Rib.anchor` called in the block would launch a shell
    end

    Rib.anchor binding # No effect (no-op) outside the block

Anchor could also be nested. The level would be shown on the prompt,
starting from 1.

### In place editing

Whenever you called:

    require 'rib/more/edit'
    Rib.edit

Rib would open an editor according to $EDITOR (`ENV['EDITOR']`) for you.
After save and leave the editor, Rib would evaluate what you had input.
This also works inside an anchor. To use it, require either rib/more/edit
or rib/more or rib/all.

### As a shell framework

The essence is:

    require 'rib'

All others are optional. The core plugins are lying in `rib/core/*.rb`, and
more plugins are lying in `rib/more/*.rb`. You can read `rib/app/ramaze.rb`
and `bin/rib-ramaze` as a Rib App reference implementation, because it's very
simple, simpler than rib-rails.

## LICENSE:

Apache License 2.0

Copyright (c) 2010-2011, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
