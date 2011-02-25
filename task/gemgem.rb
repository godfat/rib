
module Gemgem
  class << self
    attr_accessor :dir, :spec
  end

  module_function
  def gem_tag
    "#{spec.name}-#{spec.version}"
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
    @gem_files ||= gem_files_find(Pathname.new(dir))
  end

  def gem_files_find path
    path.children.select(&:file?).map{ |file| file.to_s[(dir.size+1)..-1] }.
      reject{ |file| ignore_files.find{ |ignore| file.to_s =~ ignore }}    +

    path.children.select(&:directory?).map{ |dir| gem_files_find(dir)}.flatten
  end
end

namespace :gem do

desc 'Install gem'
task :install => [:build] do
  sh("gem install pkg/#{Gemgem.gem_tag}")
end

desc 'Build gem'
task :build => [:spec] do
  sh("gem build #{Gemgem.spec.name}.gemspec")
  sh("mkdir -p pkg")
  sh("mv #{Gemgem.gem_tag}.gem pkg/")
end

desc 'Release gem'
task :release => [:spec, :check, :build] do
  sh("git tag -f #{Gemgem.gem_tag}")
  sh("git push")
  sh("git push --tags")
  sh("gem push pkg/#{Gemgem.gem_tag}")
end

task :check do
  if ENV['VERSION'].nil?
    puts("\x1b[32mExpected "                                        \
         "\x1b[36mVERSION\x1b[32m=\x1b[36mx.y.z\x1b[m")
    exit(1)

  elsif ENV['VERSION'] != (ver = Gemgem.spec.version.to_s)
    puts("\x1b[32mExpected \x1b[36mVERSION\x1b[32m=\x1b[36m#{ver} " \
         "\x1b[32mbut got\n         "                               \
         "\x1b[36mVERSION\x1b[32m=\x1b[36m#{ENV['VERSION']}\x1b[m")
    exit(2)
  end
end

end # of gem namespace

desc 'Run tests'
task :test do
  sh("#{Gem.ruby} -I lib -S bacon test/test_*.rb")
end

desc 'Generate rdoc'
task :doc => ['gem:spec'] do
  sh("yardoc --files #{Gemgem.spec.extra_rdoc_files.join(',')}")
end

require 'rake/clean'
  CLEAN.include Dir['**/*.rbc']
CLOBBER.include Dir['{doc,pkg}']
