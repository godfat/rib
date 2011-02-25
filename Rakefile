
require "#{dir = File.dirname(__FILE__)}/task/gemgem"
Gemgem.dir = dir

($LOAD_PATH << File.expand_path("#{Gemgem.dir}/lib" )).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  Gemgem.spec = Gem::Specification.new do |s|
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
    s.files            = Gemgem.gem_files
    s.test_files       = Gemgem.gem_files.grep(/test_.+?\.rb$/)
    s.extra_rdoc_files = %w[CHANGES LICENSE TODO]
    s.rdoc_options     = %w[--main README.md]
    s.require_paths    = %w[lib]
  end

  File.open("#{Gemgem.spec.name}.gemspec", 'w'){|f| f << Gemgem.spec.to_ruby}
end
