# ripl-rc
by Lin Jen-Shin ([godfat](http://godfat.org))

## LINKS:

* [github](https://github.com/godfat/ripl-rc)
* [rubygems](http://rubygems.org/gems/ripl-rc)

## DESCRIPTION:

ripl plugins collection, take you want, leave you don't.

## REQUIREMENTS:

* Tested with MRI 1.8.7, 1.9.2 and Rubinius 1.2.3, JRuby 1.6.0
* ripl

## INSTALLATION:

    gem install ripl-rc

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

    Ripl.anchor your_object_want_to_be_viewed_as_self

Another one is local binding inside a method:

    Ripl.anchor binding

Then you can look through local variables inside a method
with an interactive environment. Anchor could be nested, too.
You can anchor another object inside a _ripl_ session. The number
shown in prompt is the level of anchors, started from 1.

![Screenshot](https://github.com/godfat/ripl-rc/raw/master/screenshot.png)

Please read this blog post for other detail since I haven't
had time to update this README... Sorry about that.

* [a new feature mainly for anchor in ripl-rc ](http://blogger.godfat.org/2011/06/new-feature-mainly-for-anchor-in-ripl.html)

## FEATURES:

upon session ends:

* `require 'ripl/rc/squeeze_history'`

  Which squeezes the same input in history, both in memory
  and history file.

* `require 'ripl/rc/mkdir_history'`

  Which calls `mkdir -p` on directory which contains history
  file. For example, I put my irb_history in an directory
  might not exist before use: `~/.config/irb/irb_history`

* `require 'ripl/rc/ctrld_newline'`

  Ruby 1.9.2 has no this problem in irb, but 1.8 and ripl do.
  When hitting ctrl+d to exit ripl, it would print a newline
  instead of messing up with shell prompt.

upon exception occurs:

* `require 'ripl/rc/last_exception'`

  We can't access $! for last exception because input evaluation
  is not in the block which rescues the exception, neither can we
  update $! because it's a read only pseudo global variable.

  This plugin makes last rescued exception stored in `Ripl.last_exception`

upon formatting output:

* `require 'ripl/rc/strip_backtrace'`

  ripl prints the full backtrace upon exceptions, even the
  exceptions come from interactive environment, making it
  very verbose. This ripl plugin strips those backtrace.

* `require 'ripl/rc/color'`

  There's ripl-color_result that make use of <a href="https://github.com/michaeldv/awesome_print">awesome_print</a>,
  <a href="http://coderay.rubychan.de/">coderay</a>, or <a href="https://github.com/janlelis/wirb">wirb</a>. The problem of awesome_print is it's too
  awesome and too verbose, and the problem of coderay and
  wirb is that they are both parser based. In ripl, this should
  be as simple as just print different colors upon different
  objects, instead of inspecting it and parsing it.

  ripl/rc/color just uses a hash with Class to color mapping
  to pick up which color should be used upon a ruby object.

  To customize the color schema, inspect `Ripl.config[:rc_color]`

upon input:

* `require 'ripl/rc/multiline'`

  I need some modification on ripl-multi_line to make prompt
  work better, but not sure if I can come up a good fix and
  try to convince the author to accept those patches. So I
  just bundle and maintain it on my own. If you're using
  ripl-rc, you could use this plugin, otherwise, keep using
  ripl-multi_line.

* `require 'ripl/rc/eat_whites'`

  irb will just give you another prompt upon an empty input,
  while ripl would show you that your input is nil. I don't like
  this, because sometimes I'll keep hitting enter to separate
  between inspects. This plugin would skip inspect if the input
  is empty just like irb.

special tool:

* `require 'ripl/rc/anchor'`

  So this is my attempt to emulate pry in ripl. Instead
  trying to make pry support irb_history, colorizing, etc.,
  I think implement pry like feature in ripl is a lot easier.
  No need to be fancy, I just need the basic functionality.

  To use it, use:
  <pre><code>Ripl.anchor your_object_want_to_be_viewed_as_self</code></pre>
  or
  <pre><code>Ripl.anchor binding</code></pre>
  in your code. Other than pry ripl support, you might be
  interested in <a href="https://github.com/cldwalker/ripl-rails">ripl-rails</a> and <a href="https://github.com/cldwalker/ripl-hijack">ripl-hijack</a>, too.

about config:

* `require 'ripl/rc/noirbrc'`

  By default ripl is reading `~/.irbrc`. I don't think this
  is what people still using irb would want, because the
  configuration is totally different. This suppress that,
  make it only read `~/.riplrc`

for lazies:

* `require 'ripl/rc'`

  This requires anything above for you, and is what `ripl rc`
  and `ripl rc rails` shell commands did.

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
