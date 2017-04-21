
require 'rib/plugin'
require 'rib/api'

class Rib::Shell
  include Rib::API
  trap('INT'){ raise Interrupt }

  def self.use mod
    include mod
  end

  attr_reader :config

  # Create a new shell.
  #
  # @api public
  # @param config [Hash] The config of the shell.
  # @option config [String] :config ('~/.rib/config.rb')
  #   The path to Rib config file.
  # @option config [String] :name ('rib')
  #   The name of the shell. Used for Rib application.
  # @option config [String] :result_prompt ('=> ')
  # @option config [String] :prompt ('>> ')
  # @option config [Binding, Object] :binding (new_private_binding)
  #   The context of the shell. Could be an Object.
  # @option config [Array<String>] :exit ([nil])
  #   The keywords to exit the shell. `nil` means EOF (ctrl+d).
  # @option config [Fixnum] :line (1) The beginning of line number.
  # @option config [String] :history_file ('~/.rib/config/history.rb')
  #   (Only if {Rib::History} plugin is used) The path to history file.
  # @option config [Fixnum] :history_size (500)
  #   (Only if {Rib::History} plugin is used) Maximum numbers of history.
  # @option config [Hash<Class, Symbol>] :color (...)
  #   (Only if {Rib::Color} plugin is used) Data type colors mapping.
  # @option config [String] :autoindent_spaces ('  ')
  #   (Only if {Rib::Autoindent} plugin is used) The indented string.
  def initialize(config={})
    config[:binding] ||= new_private_binding
    self.config = {:result_prompt => '=> ',
                   :prompt        => '>> ',
                   :exit          => [nil],
                   :line          => 1    }.merge(config)
    stop
  end

  # Loops shell until user exits
  def loop
    before_loop
    start
    in_loop
    stop
    self
  rescue Exception => e
    Rib.warn("Error while running loop:\n  #{format_error(e)}")
    raise
  ensure

    after_loop
  end

  def start
    @running = true
  end

  def stop
    @running = false
  end

  def running?
    !!@running
  end

  protected
  attr_writer :config

  private
  # Avoid namespace pollution from rubygems bin stub.
  # To be specific, version and str.
  def new_private_binding
    TOPLEVEL_BINDING.eval <<-RUBY
      singleton_class.module_eval do
        Rib.warn("Removing existing main...") if method_defined?(:main)
        def main; binding; end # any way to define <main> method?
      end
      ret = main
      singleton_class.send(:remove_method, 'main') # never pollute anything
      ret
    RUBY
  end
end
