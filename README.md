# Rib [![Build Status](https://secure.travis-ci.org/godfat/rib.svg?branch=master)](http://travis-ci.org/godfat/rib) [![Coverage Status](https://coveralls.io/repos/github/godfat/rib/badge.svg)](https://coveralls.io/github/godfat/rib) [![Join the chat at https://gitter.im/godfat/rib](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/godfat/rib)

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/rib)
* [rubygems](https://rubygems.org/gems/rib)
* [rdoc](http://rdoc.info/github/godfat/rib)
* [issues](https://github.com/godfat/rib/issues) (feel free to ask for support)

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

* Tested with MRI (official CRuby) and JRuby.
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

For [Rails Spring](https://github.com/rails/spring) support, put this line
in your `~/.spring.rb`:

    require 'rib/extra/spring'

As Rack console

    rib rack

As a console for whichever the app in the current path
it should be (for now, it's either Rails or Rack)

    rib auto

If you're trying to use `rib auto` for a Rails app, you could also pass
arguments as if you were using `rib rails`. `rib auto` is merely passing
arguments.

    rib auto production --sandbox --debugger

As a fully featured interactive Ruby shell (as ripl-rc)

    rib all

As a fully featured app console (yes, some commands could be used together)

    rib all auto # or `rib auto all`, the order doesn't really matter

#### Customization

You can customize Rib's behaviour by setting a config file located at
`$RIB_HOME/config.rb`, or `./.rib/config.rb`, or `~/.rib/config.rb`, or
`~/.config/rib/config.rb`, searched by respected order. The default
would be `~/.rib/config.rb`. Since it's merely a Ruby script which would
be loaded into memory before launching Rib shell session, You can put any
customization or monkey patch there. Personally, I use all plugins provided
by Rib.

My Personal [~/.config/rib/config](https://github.com/godfat/dev-tool/blob/master/.config/rib/config.rb)

As you can see, putting `require 'rib/all'` into config file is exactly the
same as running `rib all` without a config file. What `rib all` would do is
merely require the file, and that file is also merely requiring all plugins,
but without **extra plugins**, which you should enable them one by one. This
is because most extra plugins are depending on other gems, or hard to work
with other plugins, or having strong personal tastes, so you won't want to
enable them all. Suppose you only want to use the core plugins and color
plugin, you'll put this into your config file:

``` ruby
require 'rib/core'
require 'rib/more/color'
```

You can also write your plugins there. Here's another example:

``` ruby
require 'rib/core'
require 'pp'
Rib.config[:prompt] = '$ '

module RibPP
  Rib::Shell.send(:include, self)

  def format_result result
    result_prompt + result.pretty_inspect
  end
end
```

So that we override the original format_result to pretty_inspect the result.
You can also build your own gem and then simply require it in your config
file. To see a list of overridable API, please read [api.rb][]

[api.rb]: https://github.com/godfat/rib/blob/master/lib/rib/api.rb

#### Disable enabled plugins

#### Rib home and history file

Rib home is used to store a config file and a history file, which is
searched in this order:

* $RIB_HOME
* ./.rib
* ~/.rib
* ~/.config/rib

Rib would stop searching whenever the directory is found. If none could be
found, the default would be:

* ~/.rib

So the default history file would be located at `~/.rib/history.rb`.

#### Project config and history

Since `./.rib` would be searched before `~/.rib`, you could create project
level config at the project directory, and the history would also be
separated from each other, located at the respected `./.rib/history.rb`.

To do this, you don't really have to create a project config. Creating an
empty directory for Rib home at the project directory would also work.

#### Project directory and command line options

You could set the project directory by using `-p, --prefix` command line
option. So consider this:

    cd ~/project
    rib auto

Would work the same as:

    cd /tmp
    rib -p ~/project auto

And the project config and history would be located at `~/project/.rib`.

To check for more command line options, run `rib -h`:

```
Usage: rib [ruby OPTIONS] [rib OPTIONS] [rib COMMANDS]
ruby options:
  -e, --eval LINE        Evaluate a LINE of code
  -d, --debug            Set debugging flags (set $DEBUG to true)
  -w, --warn             Turn warnings on (set $-w and $VERBOSE to true)
  -I, --include PATH     Specify $LOAD_PATH (may be used more than once)
  -r, --require LIBRARY  Require the library, before executing your script
rib options:
  -c, --config FILE      Load config from FILE
  -p, --prefix PATH      Prefix to locate the app. Default to .
  -n, --no-config        Suppress loading ~/.config/rib/config.rb
  -h, --help             Print this message
  -v, --version          Print the version
rib commands:
  all                    Load all recommended plugins
  auto                   Run as Rails or Rack console (auto-detect)
  min                    Run the minimum essence
  rack                   Run as Rack console
  rails                  Run as Rails console
```

#### Basic configuration

Rib.config                 | Functionality
-------------------------- | -------------------------------------------------
ENV['RIB_HOME']            | Specify where Rib should store config and history
Rib.config[:name]          | The name of this shell
Rib.config[:result_prompt] | Default is "=>"
Rib.config[:prompt]        | Default is ">>"
Rib.config[:binding]       | Context, default: TOPLEVEL_BINDING
Rib.config[:exit]          | Commands to exit, default [nil] # control+d

#### Plugin specific configuration

Rib.config                     | Functionality
------------------------------ | ---------------------------------------------
Rib.config[:completion]        | Completion: Bond config
Rib.config[:history_file]      | Default is "~/.rib/history.rb"
Rib.config[:history_size]      | Default is 500
Rib.config[:color]             | A hash of Class => :color mapping
Rib.config[:autoindent_spaces] | How to indent? Default is two spaces: '  '
Rib.config[:beep_threshold]    | When it should beep? Default is 5 seconds

#### List of core plugins

``` ruby
require 'rib/core' # You get all of the followings:
```

* `require 'rib/core/completion'`

  Completion from [bond][].

* `require 'rib/core/history'`

  Remember history in a history file.

* `require 'rib/core/strip_backtrace'`

  Strip backtrace before Rib.

* `require 'rib/core/readline'`

  Readline support.

* `require 'rib/core/multiline'`

  You can interpret multiple lines.

* `require 'rib/core/squeeze_history'`

  Remove duplicated input from history.

* `require 'rib/core/last_value'`

  Save the last result in `Rib.last_value` and the last exception in
  `Rib.last_exception`.

#### List of more plugins

``` ruby
require 'rib/more' # You get all of the followings:
```

* `require 'rib/more/multiline_history_file'`

  Not only readline could have multiline history, but also the history file.

* `require 'rib/more/bottomup_backtrace'`

  Show backtrace bottom-up instead of the regular top-down.

* `require 'rib/more/color'`

  Class based colorizing.

* `require 'rib/more/multiline_history'`

  Make readline aware of multiline history.

* `require 'rib/more/beep'`

  Print "\a" when the application was loaded and it's been too long.
  Configure the threshold via `Rib.config[:beep_threshold]`.

* `require 'rib/more/anchor'`

  See _As a debugging/interacting tool_.

* `require 'rib/more/caller'`

  See _Current call stack (backtrace, caller)_.

* `require 'rib/more/edit'`

  See _In place editing_.

### List of extra plugins

There's no `require 'rib/extra'` for extra plugins because they might not
be doing what you would expect or want, or having an external dependency,
or having conflicted semantics.

* `require 'rib/extra/autoindent'` This plugin is depending on:

  1. [readline_buffer][]
  2. readline plugin
  3. multiline plugin

  Which would autoindent your input.

* `require 'rib/extra/hirb'` This plugin is depending on:

  1. [hirb][]

  Which would print the result with hirb.

* `require 'rib/extra/paging'` This plugin is depending on `less` and `tput`.

  Which would pass the result to `less` (or `$PAGER` if set) if
  the result string is longer than the screen.

* `require 'rib/extra/spring'` in your `~/.spring.rb`
  for [Rails Spring](https://github.com/rails/spring) support.

[readline_buffer]: https://github.com/godfat/readline_buffer
[hirb]: https://github.com/cldwalker/hirb

### As a debugging/interacting tool

Rib could be used as a kind of debugging tool which you can set break point
in the source program.

``` ruby
require 'rib/config' # This would load your Rib config
require 'rib/more/anchor'
                     # If you enabled anchor in config, then needed not
Rib.anchor binding   # This would give you an interactive shell
                     # when your program has been executed here.
Rib.anchor 123       # You can also anchor on an object.
```

But this might be called in a loop, you might only want to
enter the shell under certain circumstance, then you'll do:

``` ruby
require 'rib/debug'

Rib.enable_anchor do
  # Only `Rib.anchor` called in the block would launch a shell
end

Rib.anchor binding # No effect (no-op) outside the block
```

Anchor could also be nested. The level would be shown on the prompt,
starting from 1.

### Current call stack (backtrace, caller)

Often time we would want to see current call stack whenever we're using
`Rib.anchor`. We could do that by simply using `caller` but it's barely
readable because it's just returning an array without any format and
it also contains backtrace from Rib itself. You could use pretty
formatting with Rib:

``` ruby
require 'rib/more/caller'

Rib.caller
```

It would use the same format for exception backtrace to show current
call stack for you. Colors, bottom up order, etc, if you're also using
the corresponding plugins.

Sometimes there are also too many stack frames which we don't care about.
In this case, we could pass arguments to `Rib.caller` in order to filter
against them. You could either pass:

* A `String` represents the name of the gem you don't care
* A `Regexp` which would be used to match against paths/methods you don't care

Examples:

``` ruby
require 'rib/more/caller'

Rib.caller 'activesupport', /rspec/
```

To remove backtrace from gem _activesupport_ and paths or methods containing
rspec as part of the name, like things for _rspec_ or _rspec-core_ and so on.
Note that if a method name also contains rspec then it would also be filtered.
Just keep that in mind when using regular expression.

Or if you don't care about any gems, only want to see application related
calls, then try to match against `%r{/gems/}` because gems are often stored
in a path containing `/gems/`:

```
Rib.caller %r{/gem/}
```

Happy debugging.

### In place editing

Whenever you called:

``` ruby
require 'rib/more/edit'

Rib.edit
```

Rib would open an editor according to `$EDITOR` (`ENV['EDITOR']`) for you.
By default it would pick vim if no `$EDITOR` was set. After save and leave
the editor, Rib would evaluate what you had input. This also works inside
an anchor. To use it, require either rib/more/edit or rib/more or rib/all.

### As a shell framework

The essence is:

``` ruby
require 'rib'
```

All others are optional. The core plugins are lying in `rib/core/*.rb`, and
more plugins are lying in `rib/more/*.rb`. You can read `rib/app/rack.rb`
and `bin/rib-rack` as a Rib App reference implementation, because it's very
simple, simpler than rib-rails.

## Other plugins and apps

* [rest-more][] `rib rest-core` Run as interactive rest-core client
* [rib-heroku][] `rib heroku` Run console on Heroku Cedar with your config

[rest-more]: https://github.com/cardinalblue/rest-more
[rib-heroku]: https://github.com/godfat/rib-heroku

## CONTRIBUTORS:

* Andrew Liu (@eggegg)
* ayaya (@ayamomiji)
* Lin Jen-Shin (@godfat)
* Mr. Big Cat (@miaout17)
* @alpaca-tc
* @bootleq
* @lulalala
* @MITSUBOSH
* @tka

## LICENSE:

Apache License 2.0 (Apache-2.0)

Copyright (c) 2011-2018, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
