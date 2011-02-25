
($LOAD_PATH << File.expand_path("#{File.dirname(__FILE__)}/lib")).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  @gemspec = Gem::Specification.new do |s|
    require 'ripl/rc/version'

    s.name    = 'ripl-rc'
    s.version = Ripl::Rc::VERSION

    s.add_dependency('ripl')
    %w[bacon rr].each{ |g|
      s.add_development_dependency(g)
    }

    s.authors     = ['Lin Jen-Shin (godfat)']
    s.email       = ['godfat (XD) godfat.org']
    s.homepage    = "http://github.com/godfat/#{s.name}"
    s.summary     = File.read("#{File.dirname(__FILE__)}/README.md").
                    match(/## DESCRIPTION:\n\n(.+)?\n\n## SYNOPSIS:/m)[1]
    s.description = s.summary
    s.executables = [s.name]

    s.date             = Time.now.strftime('%Y-%m-%d')
    s.rubygems_version = Gem::VERSION
    s.files            = gem_files
    s.test_files       = gem_files.grep(/test_.+?\.rb$/)
    s.extra_rdoc_files = %w[CHANGES LICENSE TODO]
    s.rdoc_options     = %w[--main README.md]
    s.require_paths    = %w[lib]
  end

  File.open("#{@gemspec.name}.gemspec", 'w'){ |f| f << @gemspec.to_ruby }
end

desc 'Install gem'
task 'gem:install' => [:build] do
  sh("gem install pkg/#{@gemspec.name}-#{@gemspec.version}")
end

desc 'Build gem'
task 'gem:build' => [:gemspec] do
  sh("gem build #{@gemspec.name}.gemspec")
  sh("mkdir -p pkg")
  sh("mv #{@gemspec.name}-#{@gemspec.version}.gem pkg/")
end

desc 'Release gem'
task 'gem:release' => [:spec, :check, :build] do
  sh("git tag -f #{@gemspec.name}-#{@gemspec.version}")
  sh("git push")
  sh("git push --tags")
  sh("gem push pkg/#{@gemspec.name}-#{@gemspec.version}")
end

desc 'Run tests'
task :test do
  sh("#{Gem.ruby} -I lib -S bacon test/test_*.rb")
end

desc 'Generate rdoc'
task :doc => [:gemspec] do
  sh("yardoc --files #{@gemspec.extra_rdoc_files.join(',')}")
end

require 'rake/clean'
  CLEAN.include Dir['**/*.rbc']
CLOBBER.include Dir['{doc,pkg}']

#
# desc "Create tag #{b.version_tag} and build and push " \
#      "#{b.name}-#{b.version}.gem to Rubygems"
# task :release => [:gemspec, :check_version] do
#   b.release_gem
# end

task 'gem:check' do
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
  require 'pathname'
  @gem_files ||= gem_files_find(Pathname.new(File.dirname(__FILE__)))
end

def gem_files_find path
  path.children.select(&:file?).map{ |file| file.to_s[(dir.size+1)..-1] }.
    reject{ |file| ignore_files.find{ |ignore| file.to_s =~ ignore }}    +

  path.children.select(&:directory?).map{ |dir| gem_files_find(dir)}.flatten
end
