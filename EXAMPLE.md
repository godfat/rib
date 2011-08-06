# Rib example use case

## As an interactive shell

* As IRB (reads `~/.config/rib/config.rb` writes `~/.config/rib/history.rb`)

      rib

* As Rails console

      rib rails

* As Ramaze console

      rib ramaze

* As a console for whichever the app in the current path
  it should be (for now, it's either Rails or Ramaze)

      rib auto

* As a fully featured interactive Ruby shell (as ripl-rc)

      rib all

* As a fully featured app console (yes, the commands could be used together)

      rib all auto # or `rib auto all`, the order doesn't really matter

## As a debugging/interacting tool

* Single require
* Load config

* Break point
* Edit in place

## As a shell framework

* Single require
* No automatically loading config

* Essence
* Core
* More
* Zore
* All
* App
