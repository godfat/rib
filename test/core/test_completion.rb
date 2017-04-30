
require 'rib/test'
require 'rib/core/completion'

describe Rib::Completion do
  paste :rib

  before do
    Rib::Completion.enable
  end

  would 'start bond' do
    new_shell do |sh|
      eval_binding = sh.method(:eval_binding).source_location

      mock(Bond).start(having(eval_binding: is_a(Proc))).peek_args do |*args|
        expect(args.first[:eval_binding].source_location).eq eval_binding

        args
      end
    end

    expect(Bond).started?
  end
end
