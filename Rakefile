
require "#{dir = File.dirname(__FILE__)}/task/gemgem"
Gemgem.dir = dir

($LOAD_PATH << File.expand_path("#{Gemgem.dir}/lib" )).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  Gemgem.spec = Gemgem.create do |s|
    require 'ripl/rc/version'
    s.name        = 'ripl-rc'
    s.version     = Ripl::Rc::VERSION
    s.executables = [s.name]

    %w[ripl]    .each{ |g| s.add_runtime_dependency(g, '>=0.4.1') }
    %w[bacon rr].each{ |g| s.add_development_dependency(g) }
  end

  Gemgem.write
end
