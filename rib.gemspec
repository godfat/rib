# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rib}
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Lin Jen-Shin (godfat)}]
  s.date = %q{2011-08-20}
  s.description = %q{Ruby-Interactive-ruBy -- Yet another interactive Ruby shell

Rib is based on the design of [ripl][] and the work of [ripl-rc][], some of
the features are also inspired by [pry][]. The aim of Rib is to be fully
featured and yet very easy to opt-out or opt-in other features. It shall
be simple, lightweight and modular so that everyone could customize Rib.

[ripl]: https://github.com/cldwalker/ripl
[ripl-rc]: https://github.com/godfat/ripl-rc
[pry]: https://github.com/pry/pry}
  s.email = [%q{godfat (XD) godfat.org}]
  s.executables = [
  %q{rib},
  %q{rib-all},
  %q{rib-auto},
  %q{rib-min},
  %q{rib-rails},
  %q{rib-ramaze}]
  s.files = [
  %q{.gitignore},
  %q{.gitmodules},
  %q{.travis.yml},
  %q{CHANGES.md},
  %q{CONTRIBUTORS},
  %q{Gemfile},
  %q{LICENSE},
  %q{README.md},
  %q{Rakefile},
  %q{TODO.md},
  %q{bin/rib},
  %q{bin/rib-all},
  %q{bin/rib-auto},
  %q{bin/rib-min},
  %q{bin/rib-rails},
  %q{bin/rib-ramaze},
  %q{lib/rib.rb},
  %q{lib/rib/all.rb},
  %q{lib/rib/api.rb},
  %q{lib/rib/app/auto.rb},
  %q{lib/rib/app/rails.rb},
  %q{lib/rib/app/ramaze.rb},
  %q{lib/rib/config.rb},
  %q{lib/rib/core.rb},
  %q{lib/rib/core/completion.rb},
  %q{lib/rib/core/history.rb},
  %q{lib/rib/core/multiline.rb},
  %q{lib/rib/core/readline.rb},
  %q{lib/rib/core/squeeze_history.rb},
  %q{lib/rib/core/strip_backtrace.rb},
  %q{lib/rib/core/underscore.rb},
  %q{lib/rib/debug.rb},
  %q{lib/rib/extra/autoindent.rb},
  %q{lib/rib/extra/hirb.rb},
  %q{lib/rib/more.rb},
  %q{lib/rib/more/anchor.rb},
  %q{lib/rib/more/color.rb},
  %q{lib/rib/more/edit.rb},
  %q{lib/rib/more/multiline_history.rb},
  %q{lib/rib/more/multiline_history_file.rb},
  %q{lib/rib/plugin.rb},
  %q{lib/rib/ripl.rb},
  %q{lib/rib/runner.rb},
  %q{lib/rib/shell.rb},
  %q{lib/rib/test.rb},
  %q{lib/rib/test/multiline.rb},
  %q{lib/rib/version.rb},
  %q{rib.gemspec},
  %q{screenshot.png},
  %q{task/.gitignore},
  %q{task/gemgem.rb},
  %q{test/core/test_completion.rb},
  %q{test/core/test_history.rb},
  %q{test/core/test_multiline.rb},
  %q{test/core/test_readline.rb},
  %q{test/core/test_squeeze_history.rb},
  %q{test/core/test_underscore.rb},
  %q{test/more/test_color.rb},
  %q{test/more/test_multiline_history.rb},
  %q{test/test_api.rb},
  %q{test/test_plugin.rb},
  %q{test/test_shell.rb}]
  s.homepage = %q{https://github.com/godfat/rib}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.7}
  s.summary = %q{Ruby-Interactive-ruBy -- Yet another interactive Ruby shell}
  s.test_files = [
  %q{test/core/test_completion.rb},
  %q{test/core/test_history.rb},
  %q{test/core/test_multiline.rb},
  %q{test/core/test_readline.rb},
  %q{test/core/test_squeeze_history.rb},
  %q{test/core/test_underscore.rb},
  %q{test/more/test_color.rb},
  %q{test/more/test_multiline_history.rb},
  %q{test/test_api.rb},
  %q{test/test_plugin.rb},
  %q{test/test_shell.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bond>, [">= 0"])
      s.add_development_dependency(%q<hirb>, [">= 0"])
      s.add_development_dependency(%q<readline_buffer>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bond>, [">= 0"])
      s.add_dependency(%q<hirb>, [">= 0"])
      s.add_dependency(%q<readline_buffer>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bond>, [">= 0"])
    s.add_dependency(%q<hirb>, [">= 0"])
    s.add_dependency(%q<readline_buffer>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
