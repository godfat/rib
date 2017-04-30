
require 'tempfile'

copy :setup_history do
  before do
    if readline?
      ::Readline::HISTORY.clear
      stub_readline
    end

    shell(:history_file => history_file)
  end

  after do
    tempfile.unlink if @tempfile
  end

  def tempfile
    @tempfile ||= Tempfile.new('rib')
  end

  def history_file
    tempfile.path
  end
end
