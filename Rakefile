
require "#{dir = File.dirname(__FILE__)}/task/gemgem"
Gemgem.dir = dir

($LOAD_PATH << File.expand_path("#{Gemgem.dir}/lib")).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  Gemgem.spec = Gemgem.create do |s|
    require 'rib/version'
    s.name        = 'rib'
    s.version     = Rib::VERSION

    %w[].each{ |g| s.add_runtime_dependency(g) }
    %w[bond
       hirb
       bacon
       rr
       rake].each{ |g| s.add_development_dependency(g) }
  end

  Gemgem.write
end
