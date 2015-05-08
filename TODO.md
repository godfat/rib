# TODO

* make that `rib auto` or `rib rack` accept an argument to locate the app

* Fix whenever Color.enabled? but StripBacktrace.disabled?

* Runner tests
* Documentation
* Implement exception_spy

<https://github.com/godfat/rib/commit/7a97441afeecae80f5493f4e8a4a6ba3044e2c33>

So here we have a problem. Some plugins are expecting to override
some other plugins. The order can't really be arbitrary.....
Actually, users won't care about order either. We just want to
enable/disable plugins, not really composability.

So it really should be a bucket of plugins. At least for built-in plugins,
so that we would be aware of the order. Users shouldn't pay attention
on the order of built-in plugins.
