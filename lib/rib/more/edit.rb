
require 'rib'
require 'tempfile'

module Rib::Edit
  extend Rib::Plugin
  Shell.use(self)

  module Imp
    def edit
      return if Rib::Edit.disabled?
      file = Tempfile.new(['rib.edit', '.rb'])
      file.puts(Rib.vars[:edit])
      file.close

      shell = Rib.shell
      system("#{shell.editor} #{file.path}")

      if shell.running?
        shell.send(:multiline_buffer).pop
      else
        shell.before_loop
      end

      shell.loop_eval(Rib.vars[:edit] = File.read(file.path))

    ensure
      file.close
      file.unlink
    end
  end

  def editor
    ENV['EDITOR'] || 'vim'
  end

  Rib.extend(Imp)
end
