
module Rib; end
module Rib::Rails
  module_function
  def load
    load_rails
  rescue LoadError => e
    Rib.abort("Is this a Rails app?\n  #{e}")
  end

  def load_rails
    require './config/boot'

    if File.exist?('./config/application.rb')
      Rib::Rails.load_rails3
    else
      Rib::Rails.load_rails2
      puts("Loading #{::Rails.env} environment (Rails #{::Rails.version})")
    end
  end

  def load_rails2
    ['./config/environment',
     'console_app'         ,
     'console_with_helpers'].each{ |f| require f }
  end

  def load_rails3
    # begin copied from rails/commands/console
    # Has to set the RAILS_ENV before config/application is required
    if ARGV.first && !ARGV.first.index("-") && env = ARGV.shift # has to shift the env ARGV so IRB doesn't freak
      ENV['RAILS_ENV'] = %w(production development test).detect {|e| e =~ /^#{env}/} || env
    end
    # end copied from rails/commands/console

    # begin copied from rails/commands
    require './config/application'
    ::Rails.application.require_environment!
    # end copied from rails/commands

    optparse_rails3
  end

  # copied from rails/commands/console
  def optparse_rails3 app=::Rails.application
    require 'optparse'
    options = {}

    OptionParser.new do |opt|
      opt.banner = "Usage: console [environment] [options]"
      opt.on('-s', '--sandbox', 'Rollback database modifications on exit.') { |v| options[:sandbox] = v }
      opt.on("--debugger", 'Enable ruby-debugging for the console.') { |v| options[:debugger] = v }
      opt.parse!(ARGV)
    end

    app.sandbox = options[:sandbox]
    app.load_console

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
      puts "Loading #{Rails.env} environment in sandbox (Rails #{Rails.version})"
      puts "Any modifications you make will be rolled back on exit"
    else
      puts "Loading #{Rails.env} environment (Rails #{Rails.version})"
    end
  end

  def rails?
    File.exist?('./config/boot.rb')    &&
    File.exist?('./config/environment.rb')
  end
end
