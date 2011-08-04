
require 'rib'
require 'tempfile'

module Rib::Edit
  include Rib::Plugin
  Shell.use(self)

  module EditImp
    def edit
      return if Rib::Edit.disabled?
      file = Tempfile.new(['rib.edit', '.rb'])
      file.puts(Rib.vars[:edit])
      file.close

      system("$EDITOR #{file.path}")

      Rib.shell.loop_eval(Rib.vars[:edit] = File.read(file.path))
    ensure
      file.close
      file.unlink
    end
  end

  Rib.extend(EditImp)
end
