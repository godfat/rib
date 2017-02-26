
require 'rib/test'
require 'rib/test/multiline'
require 'rib/core/multiline'

describe Rib::Multiline do
  paste :rib
  paste :setup_multiline

  test_for Rib::Multiline do
    paste :multiline
  end
end
