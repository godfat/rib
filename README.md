# ripl-rc
by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](http://github.com/godfat/ripl-rc)
* [rubygems](http://rubygems.org/gems/ripl-rc)

## DESCRIPTION:

ripl plugins collection, take you want, leave you don't.

## SYNOPSIS:

If you don't know what is __ripl__, or just want to have an
overview of what does __ripl-rc__ do, then you can use it as
a command line tool:

    ripl rc

This can be used to run rails console, too. First install
_ripl-rails_ by `gem install ripl-rails` then run this:

    ripl rc rails

Then you'll have a _ripl-rc_ flavored rails console without
setting anything (i.e. `~/.riplrc`)

If you already know what is _ripl_, you might want to setup
yourself, to be better control what you might want and what
you might not want. Then checkout FEATURES for all plugins
you can put in `~/.riplrc`.

If you want to enable all plugins, the use this:

    require 'ripl/rc'

Another thing which might worth to be mentioned is
`ripl/rc/anchor`, which is a _pry_ like feature built into
ripl. You can embed two things into ripl, one is any object:

    Ripl.anchor your_object_want_to_be_observed

Another one is local binding inside a method:

    Ripl.anchor binding

Then you can look through local variables inside a method
with an interactive environment. Anchor could be nested, too.
You can anchor another object inside a _ripl_ session. The number
shown in prompt is the level of anchors, started from 1.

![Screenshot](https://github.com/godfat/ripl-rc/raw/master/screenshot.png)

## FEATURES:

when session ends

* require 'ripl/rc/squeeze_history'
* require 'ripl/rc/mkdir_history'
* require 'ripl/rc/ctrld_newline'

result format

* require 'ripl/rc/strip_backtrace'
* require 'ripl/rc/color'

input modification

* require 'ripl/rc/multiline' # work better with anchor...
* require 'ripl/rc/eat_whites'

speical tool

* require 'ripl/rc/anchor' # pry like, use: Ripl.anchor(binding) # or obj

config

* require 'ripl/rc/noirbrc'

for lazies

* require 'ripl/rc' # for all of above

## REQUIREMENTS:

* ripl

## INSTALL:

   gem install ripl-rc

## LICENSE:

Apache License 2.0

Copyright (c) 2010, Lin Jen-Shin (godfat)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
