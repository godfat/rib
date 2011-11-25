# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rib"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = "2011-11-25"
  s.description = "Ruby-Interactive-ruBy -- Yet another interactive Ruby shell\n\nRib is based on the design of [ripl][] and the work of [ripl-rc][], some of\nthe features are also inspired by [pry][]. The aim of Rib is to be fully\nfeatured and yet very easy to opt-out or opt-in other features. It shall\nbe simple, lightweight and modular so that everyone could customize Rib.\n\n[ripl]: https://github.com/cldwalker/ripl\n[ripl-rc]: https://github.com/godfat/ripl-rc\n[pry]: https://github.com/pry/pry"
  s.email = ["godfat (XD) godfat.org"]
  s.executables = [
  "rib",
  "rib-all",
  "rib-auto",
  "rib-min",
  "rib-rails",
  "rib-ramaze"]
  s.files = [
  ".gitignore",
  ".gitmodules",
  ".travis.yml",
  "CHANGES.md",
  "CONTRIBUTORS",
  "Gemfile",
  "LICENSE",
  "README.md",
  "Rakefile",
  "TODO.md",
  "bin/rib",
  "bin/rib-all",
  "bin/rib-auto",
  "bin/rib-min",
  "bin/rib-rails",
  "bin/rib-ramaze",
  "lib/rib.rb",
  "lib/rib/all.rb",
  "lib/rib/api.rb",
  "lib/rib/app/auto.rb",
  "lib/rib/app/rails.rb",
  "lib/rib/app/ramaze.rb",
  "lib/rib/config.rb",
  "lib/rib/core.rb",
  "lib/rib/core/completion.rb",
  "lib/rib/core/history.rb",
  "lib/rib/core/multiline.rb",
  "lib/rib/core/readline.rb",
  "lib/rib/core/squeeze_history.rb",
  "lib/rib/core/strip_backtrace.rb",
  "lib/rib/core/underscore.rb",
  "lib/rib/debug.rb",
  "lib/rib/extra/autoindent.rb",
  "lib/rib/extra/hirb.rb",
  "lib/rib/more.rb",
  "lib/rib/more/anchor.rb",
  "lib/rib/more/color.rb",
  "lib/rib/more/edit.rb",
  "lib/rib/more/multiline_history.rb",
  "lib/rib/more/multiline_history_file.rb",
  "lib/rib/plugin.rb",
  "lib/rib/ripl.rb",
  "lib/rib/runner.rb",
  "lib/rib/shell.rb",
  "lib/rib/test.rb",
  "lib/rib/test/multiline.rb",
  "lib/rib/version.rb",
  "rib.gemspec",
  "screenshot.png",
  "task/.gitignore",
  "task/gemgem.rb",
  "test/core/test_completion.rb",
  "test/core/test_history.rb",
  "test/core/test_multiline.rb",
  "test/core/test_readline.rb",
  "test/core/test_squeeze_history.rb",
  "test/core/test_underscore.rb",
  "test/more/test_color.rb",
  "test/more/test_multiline_history.rb",
  "test/test_api.rb",
  "test/test_plugin.rb",
  "test/test_shell.rb"]
  s.homepage = "https://github.com/godfat/rib"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Ruby-Interactive-ruBy -- Yet another interactive Ruby shell"
  s.test_files = [
  "test/core/test_completion.rb",
  "test/core/test_history.rb",
  "test/core/test_multiline.rb",
  "test/core/test_readline.rb",
  "test/core/test_squeeze_history.rb",
  "test/core/test_underscore.rb",
  "test/more/test_color.rb",
  "test/more/test_multiline_history.rb",
  "test/test_api.rb",
  "test/test_plugin.rb",
  "test/test_shell.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
