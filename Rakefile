
gemspec = "#{File.dirname(__FILE__)}/ripl-rc.gemspec"

if File.exist?(gemspec) && File.read(gemspec).strip != ''
  require 'bundler'
  Bundler::GemHelper.install_tasks
end

desc 'Run tests'
task :test do
  sh("#{Gem.ruby} -I lib -S bacon test/test_*.rb")
end

desc 'Generate gemspec'
task :gemspec do
  require 'ripl/rc/version'
  File.open('ripl-rc.gemspec', 'w'){ |f|
    f <<
      Gem::Specification.new do |s|
        s.name    = 'ripl-rc'
        s.version = Ripl::Rc::VERSION

        s.add_dependency('ripl')
        %w[bacon rr].each{ |g|
          s.add_development_dependency(g)
        }

        s.authors     = ['Lin Jen-Shin (godfat)']
        s.email       = ['godfat (XD) godfat.org']
        s.homepage    = "http://github.com/godfat/#{s.name}"
        s.summary     = File.read("#{File.dirname(__FILE__)}/README").match(
                        /== DESCRIPTION:\n\n(.+)?\n\n== FEATURES:/m)[1]
        s.description = s.summary

        s.date             = Time.now.strftime('%Y-%m-%d')
        s.rubygems_version = Gem::VERSION
        s.files            = `git ls-files`.split("\n")
        s.test_files       = `git ls-files -- test/test_*.rb`.split("\n")
        s.extra_rdoc_files = ['CHANGES', 'README', "#{s.name}.gemspec"]
        s.rdoc_options     = ['--main', 'README']
        s.require_paths    = ['lib']
      end.to_ruby
  }
end
