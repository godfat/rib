# CHANGES

## Rib 1.1.1 -- 2013-01-25

* Fixed some multiline issue with Rubinius and JRuby.
* Properly indent for multiline prompt.
* Removed ripl compatibility layer.
* Only retry 5 times upon failures. This prevents from infinite retries.
* Don't retry on quiting.
* Added a half-baked debugger support. Try it with:
  `require 'rib/extra/debugger'; Rib.debug`

## Rib 1.1.0 -- 2012-07-18

* Support for Ruby 1.8 is dropped.
* Now `Rib::Plugin` should be extended to the module, instead of included.
  This fits more naturally with Ruby, but not really compatible with Ruby 1.8?
* [more/anchor] Fixed a bug where you run rib in top level while anchor in
  the other source, exit from the inner shell would break from the original
  call. Now you can safely exit from the inner shell and keep doing the
  original work.

## Rib 1.0.5 -- 2012-05-15

* [app/rails] Fixed SystemStackError issue. It's because ConsoleMethods
  should not pollute the Object, redefining `app` method.

## Rib 1.0.4 -- 2012-03-20

* [core/multiline] Fixed a corner case:

  ``` ruby
      1/1.to_i +
      1
  ```

* [rib] Do not crash because of a loop error. Try to relaunch the shell.

## Rib 1.0.3 -- 2012-01-21

### Bugs fixes

* [rib-rails] Fixed sandbox mode.
* [rib-rails] Bring back `reload!`, `new_session`, and `app` for Rails 3.2.0

## Rib 1.0.2 -- 2011-12-24

### Bugs fixes

* [more/multiline_history] Make sure values are initialized even if
  before_loop is called later. This helps us enable plugins on the fly.

## Rib 1.0.1 -- 2011-12-15

### Incompatible changes

* [rib] Keyword `quit` to exit rib is removed, preferring `exit`.

### Bugs fixes

* [rib] Now you exit rib with ` exit`. Thanks @ayamomiji
* [rib] Fixed -e, --eval binding. It should be TOPLEVEL_BINDING

### Enhancement

* [core/history, more/color, more/multiline_history_file, extra/autoindent]
  Make sure values are initialized even if before_loop is called later.
  This helps us enable plugins on the fly.

* [extra/autoindent] Now it depends on history plugin as well. This is not
  really needed, but would help to reduce plugins ordering issue.

## Rib 1.0.0 -- 2011-11-05

### Bugs fixes

* [more/color] Fixed a bug for displaying `1/0`. Fixed #4, thanks @bootleq

## Rib 0.9.9 -- 2011-10-26

### Bugs fixes

* [more/color] Fixed Windows coloring support.
* [more/color] Properly reset ANSI sequence.

### Enhancement

* [commands] Extract commands description under `__END__` in the commands.
  Please read [rib-rest-core][] as an example.
* [rib] Always show original errors if anything is wrong.

[rib-rest-core]: https://github.com/cardinalblue/rest-core/blob/rest-core-0.7.0/bin/rib-rest-core#L21-22

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
