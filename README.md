# Rib

by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/rib)
* [rubygems](http://rubygems.org/gems/rib)

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

* Tested with MRI 1.8.7, 1.9.2 and Rubinius 1.2, JRuby 1.6
* All gem dependencies are optional, but it's highly recommended to use
  Rib with [bond][] for tab completion.

[bond]: https://github.com/cldwalker/bond

## INSTALLATION:

    gem install rib

## SYNOPSIS:

![Screenshot](https://github.com/godfat/ripl-rc/raw/master/screenshot.png)

### As an interactive shell

As IRB (reads `~/.config/rib/config.rb` writes `~/.config/rib/history.rb`)

    rib

As Rails console

    rib rails

As Ramaze console

    rib ramaze

As a console for whichever the app in the current path
it should be (for now, it's either Rails or Ramaze)

    rib auto

As a fully featured interactive Ruby shell (as ripl-rc)

    rib all

As a fully featured app console (yes, some commands could be used together)

    rib all auto # or `rib auto all`, the order doesn't really matter

You can customize Rib's behaviour by setting `~/.config/rib/config.rb` (by
default). Since it's merely a Ruby script which would be loaded into memory
before launching Rib shell session, You can put any customization or monkey
patch there. Personally, I use all plugins provided by Rib.

<https://github.com/godfat/dev-tool/blob/master/.config/rib/config.rb>

As you can see, putting `require 'rib/all'` into config file is exactly the
same as running `rib all` without a config file. What `rib all` would do is
merely require the file, and that file is also merely requiring all plugins.
Suppose you only want to use the core plugins and color plugin, you'll put
this into your config file:

    require 'rib/core'
    require 'rib/more/color'

You can also write your plugins there. Here's another example:

    require 'rib/core'
    Rib.config[:prompt] = '$ '

    module RibPP
      include Rib::Plugin
      Rib::Shell.use(self)

      def format_result result
        require 'pp'
        result_prompt + result.pretty_inspect
      end
    end

So that we override the original behaviour to pretty_inspect the result. You
can also build your own gem and then simply require it in your config file.

### As a debugging/interacting tool

Rib could be used as a kind of debugging tool which you can set break point
in the source program.

    require 'rib/rc'     # This would load your ~/.config/rib/config.rb
    require 'rib/anchor' # If you enabled this in config, then not needed.
    Rib.anchor binding   # This would give you an interactive shell
                         # when your program has been executed here.

    # But this might be called in a loop, you might only want to
    # enter the shell under certain circumstance, then you'll need:

    require 'rib/debug'
    Rib.enable_anchor do
      # Only `Rib.anchor` called in the block would launch a shell
    end

    Rib.anchor binding # No effect (no-op) outside the block

Edit in place

### As a shell framework

The essence is:

    require 'rib'

All others are optional. The core plugins are lying in `rib/core/*.rb`,
and more plugins are lying in `rib/more/*.rb`. There are also so-called
zore plugins which are lying in `rib/zore/*.rb`, which are used as special
Rib command, such as `Rib.anchor` and `Rib.edit`. You can simply get

* All
* App

Another one is local binding inside a method:

    Ripl.anchor binding

Then you can look through local variables inside a method
with an interactive environment. Anchor could be nested, too.
You can anchor another object inside a Rib session. The number
shown in prompt is the level of anchors, starting from 1.

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
