
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
  require 'pathname'
  require 'ripl/rc/version'

  def dir
    @dir ||= File.dirname(__FILE__)
  end

  def to_regexpes pathes
    pathes.map{ |ignore|
      if ignore =~ /\*/
        to_regexpes(Dir["**/#{ignore}"])
      else
        Regexp.new("^#{Regexp.escape(ignore)}")
      end
    }.flatten
  end

  def ignore_files
    @ignore_files ||= to_regexpes(
      File.read("#{dir}/.gitignore").split("\n") + ['.git/'])
  end

  def gem_files
    @gem_files ||= gem_files_find(Pathname.new(File.dirname(__FILE__)))
  end

  def gem_files_find path
    path.children.select(&:file?).map{ |file| file.to_s[(dir.size+1)..-1] }.
      reject{ |file| ignore_files.find{ |ignore| file.to_s =~ ignore }}    +

    path.children.select(&:directory?).map{ |dir| gem_files_find(dir)}.flatten
  end

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
        s.files            = gem_files
        s.test_files       = gem_files.grep(/test_.+?\.rb$/)
        s.extra_rdoc_files = ['CHANGES', 'README', "#{s.name}.gemspec"]
        s.rdoc_options     = ['--main', 'README']
        s.require_paths    = ['lib']
      end.to_ruby
  }
end
