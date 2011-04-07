# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ripl-rc}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = %q{2011-04-08}
  s.default_executable = %q{ripl-rc}
  s.description = %q{ripl plugins collection, take you want, leave you don't.}
  s.email = ["godfat (XD) godfat.org"]
  s.executables = ["ripl-rc"]
  s.extra_rdoc_files = ["CHANGES", "CONTRIBUTORS", "LICENSE", "TODO"]
  s.files = [".gitignore", "2011-02-28.md", "CHANGES", "CONTRIBUTORS", "Gemfile", "LICENSE", "README", "README.md", "Rakefile", "TODO", "bin/ripl-rc", "lib/ripl-rc.rb", "lib/ripl/rc.rb", "lib/ripl/rc/anchor.rb", "lib/ripl/rc/color.rb", "lib/ripl/rc/ctrld_newline.rb", "lib/ripl/rc/eat_whites.rb", "lib/ripl/rc/last_exception.rb", "lib/ripl/rc/mkdir_history.rb", "lib/ripl/rc/multiline.rb", "lib/ripl/rc/noirbrc.rb", "lib/ripl/rc/squeeze_history.rb", "lib/ripl/rc/strip_backtrace.rb", "lib/ripl/rc/test.rb", "lib/ripl/rc/u.rb", "lib/ripl/rc/version.rb", "ripl-rc.gemspec", "screenshot.png", "task/gemgem.rb", "test/test_disable_shortcut.rb", "test/test_squeeze_history.rb"]
  s.homepage = %q{http://github.com/godfat/}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{ripl plugins collection, take you want, leave you don't.}
  s.test_files = ["test/test_disable_shortcut.rb", "test/test_squeeze_history.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ripl>, [">= 0"])
      s.add_development_dependency(%q<bacon>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
    else
      s.add_dependency(%q<ripl>, [">= 0"])
      s.add_dependency(%q<bacon>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
    end
  else
    s.add_dependency(%q<ripl>, [">= 0"])
    s.add_dependency(%q<bacon>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
  end
end
