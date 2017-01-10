# -*- encoding: utf-8 -*-
# stub: rib 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rib".freeze
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Lin Jen-Shin (godfat)".freeze]
  s.date = "2017-01-10"
  s.description = "Ruby-Interactive-ruBy -- Yet another interactive Ruby shell\n\nRib is based on the design of [ripl][] and the work of [ripl-rc][], some of\nthe features are also inspired by [pry][]. The aim of Rib is to be fully\nfeatured and yet very easy to opt-out or opt-in other features. It shall\nbe simple, lightweight and modular so that everyone could customize Rib.\n\n[ripl]: https://github.com/cldwalker/ripl\n[ripl-rc]: https://github.com/godfat/ripl-rc\n[pry]: https://github.com/pry/pry".freeze
  s.email = ["godfat (XD) godfat.org".freeze]
  s.executables = [
  "rib".freeze,
  "rib-all".freeze,
  "rib-auto".freeze,
  "rib-min".freeze,
  "rib-rack".freeze,
  "rib-rails".freeze]
  s.files = [
  ".gitignore".freeze,
  ".gitmodules".freeze,
  ".travis.yml".freeze,
  "CHANGES.md".freeze,
  "Gemfile".freeze,
  "LICENSE".freeze,
  "README.md".freeze,
  "Rakefile".freeze,
  "TODO.md".freeze,
  "bin/rib".freeze,
  "bin/rib-all".freeze,
  "bin/rib-auto".freeze,
  "bin/rib-min".freeze,
  "bin/rib-rack".freeze,
  "bin/rib-rails".freeze,
  "lib/rib.rb".freeze,
  "lib/rib/all.rb".freeze,
  "lib/rib/api.rb".freeze,
  "lib/rib/app/auto.rb".freeze,
  "lib/rib/app/rack.rb".freeze,
  "lib/rib/app/rails.rb".freeze,
  "lib/rib/config.rb".freeze,
  "lib/rib/core.rb".freeze,
  "lib/rib/core/completion.rb".freeze,
  "lib/rib/core/history.rb".freeze,
  "lib/rib/core/multiline.rb".freeze,
  "lib/rib/core/readline.rb".freeze,
  "lib/rib/core/squeeze_history.rb".freeze,
  "lib/rib/core/strip_backtrace.rb".freeze,
  "lib/rib/core/underscore.rb".freeze,
  "lib/rib/debug.rb".freeze,
  "lib/rib/extra/autoindent.rb".freeze,
  "lib/rib/extra/hirb.rb".freeze,
  "lib/rib/extra/paging.rb".freeze,
  "lib/rib/extra/spring.rb".freeze,
  "lib/rib/more.rb".freeze,
  "lib/rib/more/anchor.rb".freeze,
  "lib/rib/more/bottomup_backtrace.rb".freeze,
  "lib/rib/more/caller.rb".freeze,
  "lib/rib/more/color.rb".freeze,
  "lib/rib/more/edit.rb".freeze,
  "lib/rib/more/multiline_history.rb".freeze,
  "lib/rib/more/multiline_history_file.rb".freeze,
  "lib/rib/plugin.rb".freeze,
  "lib/rib/runner.rb".freeze,
  "lib/rib/shell.rb".freeze,
  "lib/rib/test.rb".freeze,
  "lib/rib/test/multiline.rb".freeze,
  "lib/rib/version.rb".freeze,
  "rib.gemspec".freeze,
  "task/README.md".freeze,
  "task/gemgem.rb".freeze,
  "test/core/test_completion.rb".freeze,
  "test/core/test_history.rb".freeze,
  "test/core/test_multiline.rb".freeze,
  "test/core/test_readline.rb".freeze,
  "test/core/test_squeeze_history.rb".freeze,
  "test/core/test_strip_backtrace.rb".freeze,
  "test/core/test_underscore.rb".freeze,
  "test/extra/test_autoindent.rb".freeze,
  "test/more/test_caller.rb".freeze,
  "test/more/test_color.rb".freeze,
  "test/more/test_multiline_history.rb".freeze,
  "test/test_api.rb".freeze,
  "test/test_plugin.rb".freeze,
  "test/test_runner.rb".freeze,
  "test/test_shell.rb".freeze]
  s.homepage = "https://github.com/godfat/rib".freeze
  s.licenses = ["Apache License 2.0".freeze]
  s.rubygems_version = "2.6.8".freeze
  s.summary = "Ruby-Interactive-ruBy -- Yet another interactive Ruby shell".freeze
  s.test_files = [
  "test/core/test_completion.rb".freeze,
  "test/core/test_history.rb".freeze,
  "test/core/test_multiline.rb".freeze,
  "test/core/test_readline.rb".freeze,
  "test/core/test_squeeze_history.rb".freeze,
  "test/core/test_strip_backtrace.rb".freeze,
  "test/core/test_underscore.rb".freeze,
  "test/extra/test_autoindent.rb".freeze,
  "test/more/test_caller.rb".freeze,
  "test/more/test_color.rb".freeze,
  "test/more/test_multiline_history.rb".freeze,
  "test/test_api.rb".freeze,
  "test/test_plugin.rb".freeze,
  "test/test_runner.rb".freeze,
  "test/test_shell.rb".freeze]
end
