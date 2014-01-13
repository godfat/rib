
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
    @running = false
  end

  # Loops shell until user exits
  def loop
    before_loop
    @running = true
    in_loop
    self
  rescue Exception => e
    Rib.warn("Error while running loop:\n  #{format_error(e)}")
    raise
  ensure
    @running = false
    after_loop
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
    context = Object.new
    def context.__rib_binding__
      binding
    end
    binding = context.__rib_binding__
    context.singleton_class.__send__(:remove_method, :__rib_binding__)
    binding
  end
end
