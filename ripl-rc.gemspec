# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ripl-rc}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = %q{2011-02-24}
  s.description = %q{ripl plugins collection}
  s.email = ["godfat (XD) godfat.org"]
  s.extra_rdoc_files = ["CHANGES", "README", "ripl-rc.gemspec"]
  s.files = [".gitignore", "CHANGES", "Gemfile", "LICENSE", "README", "README.rdoc", "Rakefile", "TODO", "ripl-rc.gemspec", "lib/ripl/rc.rb", "lib/ripl/rc/color.rb", "lib/ripl/rc/ctrld_newline.rb", "lib/ripl/rc/eat_whites.rb", "lib/ripl/rc/squeeze_history.rb", "lib/ripl/rc/strip_backtrace.rb", "lib/ripl/rc/version.rb", "test/test_squeeze_history.rb"]
  s.homepage = %q{http://github.com/godfat/ripl-rc}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{ripl plugins collection}
  s.test_files = ["test/test_squeeze_history.rb"]

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
