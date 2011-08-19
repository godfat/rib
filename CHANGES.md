# Rib CHANGES

## Rib 0.9.1 --

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
