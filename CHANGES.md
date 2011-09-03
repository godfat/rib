# Rib CHANGES

## Rib 0.9.5 -- 2011-09-03

* [rib-rails] Fixed Rails3 (sandbox) and Rails2 (env) console. Thanks bootleq
* [rib-min] Fixed not being really minimum
* [rib] Now you can run it with `rib -wdIlib`, isn't it convenient?
  It's equivalent to `rib -w -d -I lib` or `rib -w -d -I=lib`

## Rib 0.9.4 -- 2011-09-01

* [rib-rails] So now we replicated what Rails did for its console, both for
  Rails 2 and Rails 3. You can now fully use `rib rails` or `rib auto` as
  `rails console` or `./script/console` in respect to Rails 2 or 3. For
  example, it works for:

      rib auto production
      rib rails production
      rib auto test --debugger # remember to add ruby-debug(19)? to Gemfile
      rib auto test --sandbox
      rib rails test --debugger --sandbox

  It should also make Rails 3 print SQL log to stdout. Thanks tka.

## Rib 0.9.3 -- 2011-08-28

* [rib] Calling `Rib.shell` would no longer automatically `require 'rib/core'`
  anymore. This is too messy. We should only do this in `bin/rib`. See:
  commit #7a97441afeecae80f5493f4e8a4a6ba3044e2c33

      require 'rib/more/anchor'
      Rib.anchor 123

  Should no longer crashed... Thanks Andrew.

## Rib 0.9.2 -- 2011-08-25

* [extra/autoindent] It has been greatly improved. A lot more accurate.
* [extra/autoindent] Fixed a bug when you're typing too fast upon rib
                     launching, it might eat your input. Thanks bootleq.

## Rib 0.9.1 -- 2011-08-19

* [extra/autoindent] Autoindent plugin help you indent multiline editing.
  Note: This plugin is depending on [readline_buffer][], thus GNU Readline.

* [ripl] After `require 'rib/ripl'`, ripl plugins should be usable for rib.

* [rib] Introduce `ENV['RIB_HOME']` to set where to store config and history.
  By default, it's `~/.rib` now, but it would first search for existing
  config or history, which would first try to see `~/.rib/config.rb`, and
  then `~/.rib/history.rb`. If Rib can find anything there, then `RIB_HOME`
  would be set to `~/.rib`, the same goes to `~/.config/rib`.
  In short, by default `RIB_HOME` is `~/.rib`, but the old `~/.config/rib`
  still works.

[readline_buffer]: https://github.com/godfat/readline_buffer

## Rib 0.9.0 -- 2011-08-14

* First serious release!
* So much enhancement over ripl-rc!
