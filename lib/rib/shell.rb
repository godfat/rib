
require 'rib/plugin'
require 'rib/api'

class Rib::Shell
  include Rib::API
  trap('INT'){ raise Interrupt }

  def self.use mod
    include mod
  end

  attr_reader :config
  def initialize(config={})
    self.config = {
      :result_prompt => '=> '                    ,
      :prompt        => '>> '                    ,
      :binding       => TOPLEVEL_BINDING         ,
      :exit          => [nil, 'exit', 'quit']    ,
      :line          => 1
    }.merge(config)
    @running = false
  end

  # Loops shell until user exits
  def loop
    before_loop
    @running = true
    in_loop
    self
  ensure
    @running = false
    after_loop
  end

  def running?
    !!@running
  end

  protected
  attr_writer :config
  attr_accessor :error_raised
end
