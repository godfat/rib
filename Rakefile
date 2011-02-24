
gemspec = "#{File.dirname(__FILE__)}/ripl-rc.gemspec"

if File.exist?(gemspec) && File.read(gemspec).strip != ''
  require 'bundler'
  # please do me a favor, don't use thor!!
  b = Bundler::GemHelper.new(File.dirname(__FILE__))
  Bundler::GemHelper.send(:public, :name, :version, :version_tag)

  desc "Build #{b.name}-#{b.version}.gem into the pkg directory"
  task :build => [:gemspec] do
    b.build_gem
  end

  desc "Build and install #{b.name}-#{b.version}.gem into system gems"
  task :install => [:gemspec] do
    b.install_gem
  end

  desc "Create tag #{b.version_tag} and build and push " \
       "#{b.name}-#{b.version}.gem to Rubygems"
  task :release => [:gemspec, :check_version] do
    b.release_gem
  end

  task :check_version do
    if ENV['VERSION'].nil?
      puts("\x1b[32mPlease provide "                     \
           "\x1b[36mVERSION\x1b[32m=\x1b[36mx.y.z\x1b[m")
      exit(1)

    elsif ENV['VERSION'] != b.version.to_s
      puts("\x1b[32mYou gave \x1b[36mVERSION\x1b[32m=\x1b[36m#{b.version} " \
           "\x1b[32mbut got\n         \x1b[36m"                             \
           "VERSION\x1b[32m=\x1b[36m#{ENV['VERSION']}\x1b[m")
      exit(2)
    end
  end
end

desc 'Generate rdoc'
task :rdoc do
  sh('rdoc --output rdoc --main README.rdoc')
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
