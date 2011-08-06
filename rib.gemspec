# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rib}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Lin Jen-Shin (godfat)}]
  s.date = %q{2011-08-06}
  s.description = %q{ripl plugins collection, take you want, leave you don't.}
  s.email = [%q{godfat (XD) godfat.org}]
  s.executables = [
  %q{rib},
  %q{rib-auto},
  %q{rib-rails},
  %q{rib-ramaze}]
  s.extra_rdoc_files = [
  %q{CHANGES},
  %q{CONTRIBUTORS},
  %q{LICENSE},
  %q{TODO}]
  s.files = [
  %q{.gitignore},
  %q{.gitmodules},
  %q{.travis.yml},
  %q{2011-02-28.md},
  %q{CHANGES},
  %q{CONTRIBUTORS},
  %q{Gemfile},
  %q{LICENSE},
  %q{README},
  %q{README.md},
  %q{Rakefile},
  %q{TODO},
  %q{bin/rib},
  %q{bin/rib-auto},
  %q{bin/rib-rails},
  %q{bin/rib-ramaze},
  %q{lib/rib.rb},
  %q{lib/rib/all.rb},
  %q{lib/rib/api.rb},
  %q{lib/rib/app/auto.rb},
  %q{lib/rib/app/hirb.rb},
  %q{lib/rib/app/rails.rb},
  %q{lib/rib/app/ramaze.rb},
  %q{lib/rib/core.rb},
  %q{lib/rib/core/completion.rb},
  %q{lib/rib/core/history_file.rb},
  %q{lib/rib/core/readline.rb},
  %q{lib/rib/core/underscore.rb},
  %q{lib/rib/debug.rb},
  %q{lib/rib/more.rb},
  %q{lib/rib/more/color.rb},
  %q{lib/rib/more/multiline.rb},
  %q{lib/rib/more/multiline_history.rb},
  %q{lib/rib/more/multiline_history_file.rb},
  %q{lib/rib/more/squeeze_history.rb},
  %q{lib/rib/more/strip_backtrace.rb},
  %q{lib/rib/plugin.rb},
  %q{lib/rib/runner.rb},
  %q{lib/rib/shell.rb},
  %q{lib/rib/test.rb},
  %q{lib/rib/version.rb},
  %q{lib/rib/zore.rb},
  %q{lib/rib/zore/anchor.rb},
  %q{lib/rib/zore/edit.rb},
  %q{rib.gemspec},
  %q{screenshot.png},
  %q{task/.gitignore},
  %q{task/gemgem.rb},
  %q{test/core/test_completion.rb},
  %q{test/core/test_history_file.rb},
  %q{test/core/test_readline.rb},
  %q{test/core/test_underscore.rb},
  %q{test/more/test_color.rb},
  %q{test/more/test_squeeze_history.rb},
  %q{test/test_api.rb},
  %q{test/test_plugin.rb},
  %q{test/test_shell.rb}]
  s.homepage = %q{https://github.com/godfat/rib}
  s.rdoc_options = [
  %q{--main},
  %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.7}
  s.summary = %q{ripl plugins collection, take you want, leave you don't.}
  s.test_files = [
  %q{test/core/test_completion.rb},
  %q{test/core/test_history_file.rb},
  %q{test/core/test_readline.rb},
  %q{test/core/test_underscore.rb},
  %q{test/more/test_color.rb},
  %q{test/more/test_squeeze_history.rb},
  %q{test/test_api.rb},
  %q{test/test_plugin.rb},
  %q{test/test_shell.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bond>, [">= 0"])
      s.add_development_dependency(%q<hirb>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
    else
      s.add_dependency(%q<bond>, [">= 0"])
      s.add_dependency(%q<hirb>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
    end
  else
    s.add_dependency(%q<bond>, [">= 0"])
    s.add_dependency(%q<hirb>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
  end
end
