# Rib TODO

* Automatically generate (n-1)^2 tests for each plugin where n
  is the number of plugins. This would test all the *combination* of
  plugins usage, but not for *permutations*.
* Runner tests
* Documentation

* Reduce test time (by remove stupid @shell.should.eq @shell,
  and remove Rib.plugins.each(&:disable) in before block
* Fix Rubinius weird Runtime BOOM error

* Implement exception_spy
