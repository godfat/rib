
module Gemgem
  class << self
    attr_accessor :dir, :spec
  end

  module_function
  def gem_tag
    "#{spec.name}-#{spec.version}"
  end

  def write
    File.open("#{spec.name}.gemspec", 'w'){ |f| f << spec.to_ruby }
  end

  def gem_files
    require 'pathname'
    @gem_files ||= gem_files_find(Pathname.new(dir)).sort
  end

  # protected
  def gem_files_find path
    path.children.select(&:file?).map{ |file| file.to_s[(dir.size+1)..-1] }.
      reject{ |file| ignore_files.find{ |ignore| file.to_s =~ ignore }}    +

    path.children.select(&:directory?).map{ |dir| gem_files_find(dir)}.flatten
  end

  def ignore_files
    @ignore_files ||= to_regexpes(
      File.read("#{dir}/.gitignore").split("\n") + ['.git/']).compact
  end

  def to_regexpes pathes
    pathes.map{ |ignore|
      if ignore.strip == ''
        nil
      elsif ignore =~ /\*/
        to_regexpes(Dir["**/#{ignore}"])
      else
        Regexp.new("^#{Regexp.escape(ignore)}")
      end
    }.flatten
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
  sh("git tag #{Gemgem.gem_tag}")
  sh("git push")
  sh("git push --tags")
  sh("gem push pkg/#{Gemgem.gem_tag}")
end

task :check do
  ver = Gemgem.spec.version.to_s

  if ENV['VERSION'].nil?
    puts("\x1b[35mExpected "                                        \
         "\x1b[33mVERSION\x1b[35m=\x1b[33m#{ver}\x1b[m")
    exit(1)

  elsif ENV['VERSION'] != ver
    puts("\x1b[35mExpected \x1b[33mVERSION\x1b[35m=\x1b[33m#{ver} " \
         "\x1b[35mbut got\n         "                               \
         "\x1b[33mVERSION\x1b[35m=\x1b[33m#{ENV['VERSION']}\x1b[m")
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

task :default do
  Rake.application.options.show_task_pattern = /./
  Rake.application.display_tasks_and_comments
end

require 'rake/clean'
  CLEAN.include Dir['**/*.rbc']
CLOBBER.include Dir['{doc,pkg}']
