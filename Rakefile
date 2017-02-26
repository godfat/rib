
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
  %w[screenshot.png asciicast.json].each do |file|
    s.files.delete(file)
  end
end
