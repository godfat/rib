# CHANGES

## Rib 1.5.1 -- 2017-03-09

* [more/beep] This plugin would beep via `print "\a"` when the application
  was loaded and it's been too long. Configure the time via
  `Rib.config[:beep_threshold]`, default is 5 seconds.

## Rib 1.5.0 -- 2017-02-27

* Removed Ramaze direct support. Use Rack instead.
* Introduced API#format_backtrace
* Introduced API#puts
* [more/anchor] Fixed multiline support when anchoring on an object
* [more/caller] Added for showing formatted call stack
* [core/underscore] This is changed to `core/last_value`, and the API is
  changed to `Rib.last_value` and `Rib.last_exception`. Surely this is less
  intrusive and more compatible for things like `Rib.anchor 42` because
  now literal integers are frozen and we cannot define methods on them.
  Also, using `Rib.last_value` is surely more descriptive. Of course,
  being able to type `_` is so much easier, but you could just add a plugin
  which defines `def _; Rib.last_value; end` and keep using `_` for your
  own taste!

## Rib 1.4.0 -- 2016-11-11

* Search Rib home by directories rather than config/history file.
* Respect prefix option for detecting Rib home.
* Update help message for `-n`, which won't load any config.
* Change `Rib.config[:config]` to `Rib.config_path`.
* [app/rails] Fix loading boot file when using prefix option.
* [app/auto] Fix two variable shadowing warnings.

## Rib 1.3.1 -- 2016-11-03

* [core/strip_backtrace], [more/color] No longer show `./` for current path.
  This would be more friendly to some editors like Sublime.

## Rib 1.3.0 -- 2016-06-28

* Now `rib` would accept `-p` or `--prefix` to allow setting where we want to
  load the application. This is useful when we don't want to `cd` into a
  directory and `rib auto` or `rib rails` from there.

## Rib 1.2.91 -- 2016-01-06

* [core/multiline] Fixed a case for JRuby 9.0.4.0.
* [extra/paging] Disable paging if `tput` is not found.
* [extra/spring] Require `rib/extra/spring` in your `~/.spring` to enable
  Rails Spring support. #11 (thanks @swrobel)

## Rib 1.2.9 -- 2015-09-23

* [extra/paging] Disable paging if your terminal is nil. (e.g. on Heroku)

## Rib 1.2.8 -- 2015-09-23

* [extra/paging] Disable paging if your terminal is dumb. (e.g. on Heroku)

## Rib 1.2.7 -- 2015-01-28

* [more/bottomup_backtrace] A new plugin which prints the backtrace bottom-up.
  Ref: <http://yellerapp.com/posts/2015-01-22-upside-down-stacktraces.html>

## Rib 1.2.6 -- 2014-11-07

* [extra/autoindent] Now `module_function` would indent correctly.
* [extra/autoindent] Now `else` in `case` would indent correctly.
* [extra/autoindent] Fixed printing end clause twice. (performance fix)
* [extra/multiline] Fixed in some cases it's not recognized as multiline
  in Rubinius (rbx).

## Rib 1.2.5 -- 2014-03-13

* Fixed binding. Sorry my bad.

## Rib 1.2.4 -- 2014-03-13

* Fixed a regression introduced in 1.2.0. Now `rib all -e 'p 123'` should
  work properly. Previously -e is ignored after rib apps.
* Fixed a long standing Windows issue, where `rib all` did not work because
  there's no `which` on Windows. Now we fall back to `where`.
* Warn on removing main method on `TOPLEVEL_BINDING`. Not sure if this
  would happen, but at least we could have a warning.

## Rib 1.2.3 -- 2014-02-08

* [extra/paging] Properly disable paging if less or ENV['PAGER'] is not
  available.

## Rib 1.2.2 -- 2014-01-23

* From now on, we support project specific config file located on
  "./.rib/config.rb". Note that if there's a project specific config file,
  your home config would not be loaded at all. The history file would also
  be put into "./.rib/history.rb". You might want to ignore it from your
  repository to avoid leaking confidential information.

* [extra/paging] Now we strip ANSI sequences before calculating if we need
  a pager. This should make it much more accurate.

## Rib 1.2.1 -- 2014-01-18

* Fixed a bug where it cannot properly elegantly handle errors when loading
  the config file.

* [extra/paging] This plugin would try to use $PAGER and by default less to
  paginate for output which cannot fit in a screen.

* [more/edit] Now by default it would pick vim if $EDITOR is not set.

## Rib 1.2.0 -- 2014-01-17

* We no longer really eval on TOPLEVEL_BINDING, but a private binding
  derived from TOPLEVEL_BINDING. This is due to RubyGems bin stub would
  actually pollute TOPLEVEL_BINDING, leaving `str` and `version` as
  local variables. I would like to avoid them, thus introducing this change.
  Please let me know if this breaks anything, thanks!

* [core/multiline] Fixed a multiline detection for Rubinius.

## Rib 1.1.6 -- 2013-08-14

* [more/color] Fixed inspecting recursive array and hash.

## Rib 1.1.5 -- 2013-07-11

* Fixed `rib -h` with commands don't have a description.
* Added a description for `rib rack`

## Rib 1.1.4 -- 2013-07-11

* Further fixed a bug for displaying a BasicObject. Rib should never crash.
* Added `rib-rack` executable which could load the app in config.ru,
  accessible from calling `app` in the console. Also works for `rib-auto`

## Rib 1.1.3 -- 2013-05-08

* Fixed a bug where if user input doesn't respond to `==` would crash rib.

## Rib 1.1.2 -- 2013-04-02

* [core/multiline] Ruby 2.0 compatibility.

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
