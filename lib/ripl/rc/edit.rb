
require 'ripl/rc/u'
require 'tempfile'

module Ripl::Rc::Edit
  include Ripl::Rc::U

  module EditImp
    def edit
      return if Ripl::Rc::Edit.disabled?
      file = Tempfile.new(['ripl.rc.edit', '.rb'])
      file.puts(Ripl.config[:rc_edit])
      file.close

      system("$EDITOR #{file.path}")

      Ripl.config[:rc_shells].last.loop_eval(
        Ripl.config[:rc_edit] = File.read(file.path))
    ensure
      file.close
      file.unlink
    end
  end
end

Ripl::Shell.include(Ripl::Rc::Edit)
# define Ripl.edit
Ripl    .extend(Ripl::Rc::Edit::EditImp)
Ripl::Rc.extend(Ripl::Rc::Edit::EditImp)
