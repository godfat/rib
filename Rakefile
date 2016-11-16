
begin
  require "#{__dir__}/task/gemgem"
rescue LoadError
  sh 'git submodule update --init --recursive'
  exec Gem.ruby, '-S', $PROGRAM_NAME, *ARGV
end

Gemgem.init(__dir__) do |s|
  require 'rib/version'
  s.name    = 'rib'
  s.version = Rib::VERSION
  s.files.delete('screenshot.png')
end
