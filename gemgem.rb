
require 'pathname'

module Gemgem
  class << self
    attr_accessor :dir, :spec
  end

  module_function
  def create
    yield(spec = Gem::Specification.new{ |s|
      s.authors     = ['Lin Jen-Shin (godfat)']
      s.email       = ['godfat (XD) godfat.org']
      s.homepage    = "http://github.com/godfat/#{s.name}"

      s.summary     = File.read("#{Gemgem.dir}/README").
                      match(/DESCRIPTION:\n\n(.+?)\n\n/m)[1]
      s.description = s.summary

      s.extra_rdoc_files = %w[CHANGES CONTRIBUTORS LICENSE TODO]
      s.rdoc_options     = %w[--main README]
      s.rubygems_version = Gem::VERSION
      s.date             = Time.now.strftime('%Y-%m-%d')
      s.files            = gem_files
      s.test_files       = gem_files.grep(%r{^test/(.+?/)*test_.+?\.rb$})
      s.require_paths    = %w[lib]
    })
    spec
  end

  def gem_tag
    "#{spec.name}-#{spec.version}"
  end

  def write
    File.open("#{dir}/#{spec.name}.gemspec", 'w'){ |f| f << spec.to_ruby }
  end

  def all_files
    @all_files ||= find_files(Pathname.new(dir)).map{ |file|
      if file.to_s =~ %r{\.git/}
        nil
      else
        file.to_s
      end
    }.compact.sort
  end

  def gem_files
    @gem_files ||= all_files - ignored_files
  end

  def ignored_files
    @ignored_file ||= all_files.select{ |path| ignore_patterns.find{ |ignore|
      path =~ ignore && !git_files.include?(path)}}
  end

  def git_files
    @git_files ||= if File.exist?("#{dir}/.git")
                     `git ls-files`.split("\n")
                   else
                     []
                   end
  end

  # protected
  def find_files path
    path.children.select(&:file?).map{|file| file.to_s[(dir.size+1)..-1]} +
    path.children.select(&:directory?).map{|dir| find_files(dir)}.flatten
  end

  def ignore_patterns
    @ignore_files ||= expand_patterns(
      File.read("#{dir}/.gitignore").split("\n").reject{ |pattern|
        pattern.strip == ''
      }).map{ |pattern| %r{^([^/]+/)*?#{Regexp.escape(pattern)}(/[^/]+)*?$} }
  end

  def expand_patterns pathes
    pathes.map{ |path|
      if path !~ /\*/
        path
      else
        expand_patterns(
          Dir[path] +
          Pathname.new(File.dirname(path)).children.select(&:directory?).
            map{ |prefix| "#{prefix}/#{File.basename(path)}" })
      end
    }.flatten
  end
end

namespace :gem do

desc 'Install gem'
task :install => [:build] do
  sh("#{Gem.ruby} -S gem install pkg/#{Gemgem.gem_tag}")
end

desc 'Build gem'
task :build => [:spec] do
  sh("#{Gem.ruby} -S gem build #{Gemgem.spec.name}.gemspec")
  sh("mkdir -p pkg")
  sh("mv #{Gemgem.gem_tag}.gem pkg/")
end

desc 'Release gem'
task :release => [:spec, :check, :build] do
  sh("git tag #{Gemgem.gem_tag}")
  sh("git push")
  sh("git push --tags")
  sh("#{Gem.ruby} -S gem push pkg/#{Gemgem.gem_tag}.gem")
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
  sh("yardoc -o rdoc --main README.md" \
     " --files #{Gemgem.spec.extra_rdoc_files.join(',')}")
end

desc 'Removed ignored files'
task :clean => ['gem:spec'] do
  trash = "~/.Trash/#{Gemgem.spec.name}/"
  sh "mkdir -p #{trash}" unless File.exist?(File.expand_path(trash))
  Gemgem.ignored_files.each{ |file| sh "mv #{file} #{trash}" }
end


task :default do
  Rake.application.options.show_task_pattern = /./
  Rake.application.display_tasks_and_comments
end
