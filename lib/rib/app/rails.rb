# frozen_string_literal: true

module Rib; module Rails
  module_function
  def load
    load_rails
  rescue LoadError => e
    Rib.abort("Error: #{e}", "Is this a Rails app?")
  end

  def load_rails
    require path_for('boot')

    if File.exist?(path_for('application.rb'))
      Rib::Rails.load_rails3
    else
      Rib::Rails.load_rails2
    end
  end

  def load_rails2
    optparse_env
    Rib.silence{
      # rails 2 is so badly written
      require 'stringio'
       stderr = $stderr
      $stderr = StringIO.new
      Object.const_set('RAILS_ENV', ENV['RAILS_ENV'] || 'development')
      $stderr = stderr
    }

    # copied from commands/console
    [path_for('environment'),
     'console_app',
     'console_with_helpers'].each{ |f| require f }

    optparse_rails
  end

  def load_rails3
    optparse_env

    # copied from rails/commands
    require path_for('application')
    ::Rails.application.require_environment!

    optparse_rails
  end

  # copied from rails/commands/console
  def optparse_env
    # Has to set the RAILS_ENV before config/application is required
    if ARGV.first && !ARGV.first.index("-") && env = ARGV.shift # has to shift the env ARGV so IRB doesn't freak
      ENV['RAILS_ENV'] = %w(production development test).detect {|e| e =~ /^#{env}/} || env
    end
  end

  # copied from rails/commands/console
  def optparse_rails
    require 'optparse'
    options = {}

    OptionParser.new do |opt|
      opt.banner = "Usage: rib rails [environment] [options]"
      opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
      opt.on("--debugger", 'Enable ruby-debugging for the console.') { |v| options[:debugger] = v }
      opt.parse!(ARGV)
    end

      # rails 3
    if ::Rails.respond_to?(:application) && (app = ::Rails.application)
      # rails 3.1
      if app.respond_to?(:sandbox)
        app.sandbox = options[:sandbox]
        app.load_console
      # rails 3.0
      else
        app.load_console(options[:sandbox])
      end
    else
      # rails 2
      require 'console_sandbox' if options[:sandbox]
    end

    if options[:debugger]
      begin
        require 'ruby-debug'
        puts "=> Debugger enabled"
      rescue Exception
        puts "You need to install ruby-debug to run the console in debugging mode. With gems, use 'gem install ruby-debug'"
        exit
      end
    end

    if options[:sandbox]
      puts "Loading #{::Rails.env} environment in sandbox (Rails #{::Rails.version})"
      puts "Any modifications you make will be rolled back on exit"
    else
      puts "Loading #{::Rails.env} environment (Rails #{::Rails.version})"
    end

    # rails 3.2
    if ::Rails.const_defined?(:ConsoleMethods)
      Rib.shell.eval_binding.eval('extend ::Rails::ConsoleMethods')
    end
  end

  def rails?
    File.exist?(path_for('boot.rb')) &&
      File.exist?(path_for('environment.rb'))
  end

  def path_for file
    File.expand_path("#{Rib.config[:prefix]}/config/#{file}")
  end
end; end
