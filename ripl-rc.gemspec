# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ripl-rc}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Lin Jen-Shin (godfat)}]
  s.date = %q{2011-06-01}
  s.description = %q{ripl plugins collection, take you want, leave you don't.}
  s.email = [%q{godfat (XD) godfat.org}]
  s.executables = [%q{ripl-rc}]
  s.extra_rdoc_files = [
  %q{CHANGES},
  %q{CONTRIBUTORS},
  %q{LICENSE},
  %q{TODO}]
  s.files = [
  %q{.gitignore},
  %q{.gitmodules},
  %q{2011-02-28.md},
  %q{CHANGES},
  %q{CONTRIBUTORS},
  %q{Gemfile},
  %q{LICENSE},
  %q{README},
  %q{README.md},
  %q{Rakefile},
  %q{TODO},
  %q{bin/ripl-rc},
  %q{lib/ripl-rc.rb},
  %q{lib/ripl/rc.rb},
  %q{lib/ripl/rc/anchor.rb},
  %q{lib/ripl/rc/color.rb},
  %q{lib/ripl/rc/ctrld_newline.rb},
  %q{lib/ripl/rc/eat_whites.rb},
  %q{lib/ripl/rc/last_exception.rb},
  %q{lib/ripl/rc/mkdir_history.rb},
  %q{lib/ripl/rc/multiline.rb},
  %q{lib/ripl/rc/multiline_history.rb},
  %q{lib/ripl/rc/multiline_history_file.rb},
  %q{lib/ripl/rc/noirbrc.rb},
  %q{lib/ripl/rc/squeeze_history.rb},
  %q{lib/ripl/rc/strip_backtrace.rb},
  %q{lib/ripl/rc/test.rb},
  %q{lib/ripl/rc/u.rb},
  %q{lib/ripl/rc/version.rb},
  %q{ripl-rc.gemspec},
  %q{screenshot.png},
  %q{task/gemgem.rb},
  %q{test/test_disable_shortcut.rb},
  %q{test/test_squeeze_history.rb}]
  s.homepage = %q{https://github.com/godfat/}
  s.rdoc_options = [
  %q{--main},
  %q{README}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{ripl plugins collection, take you want, leave you don't.}
  s.test_files = [
  %q{test/test_disable_shortcut.rb},
  %q{test/test_squeeze_history.rb}]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ripl>, [">= 0.4.1"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
    else
      s.add_dependency(%q<ripl>, [">= 0.4.1"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
    end
  else
    s.add_dependency(%q<ripl>, [">= 0.4.1"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
  end
end
