
# never make those convenient methods public!
Kernel.module_eval{ private :debugger }

# remove alias 'backtrace'
class ::Debugger::WhereCommand
  def self.help_command
    'where'
  end
end

# please have a more consistent name
::Debugger::EditCommand = ::Debugger::Edit
