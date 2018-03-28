# Ruby Gem native extensions

Some Ruby Gems depend on C/C++ native extensions which makes it platform dependent. `nokogiri` will
be one of these. [Traveling Ruby](https://github.com/phusion/traveling-ruby) provides a solution to
include native extensions for several specific platforms, however, the extensions provided by
Traveling Ruby is quite outdated and it is quite non-trivial to build its packages. I encountered
failures with `yum update` in the `chroot` environment every now and then. Thus, I would rather
build it on my own.

As a workaround, we can build specific library in `centos:centos6` container and copy over the
extensions. Note that the final artifact of the extension should contain the following (use
`nokogiri` as an example), which can be found at
`ruby/2.2.0/extensions/x86_64-linux/2.2.0-static/xxxx` in your bundle `--path`:

```
2.2.0
└── extensions
    └── x86_64-linux
        └── 2.2.0-static
            └── nokogiri-1.8.2
                ├── gem.build_complete
                ├── gem_make.out
                ├── mkmf.log
                └── nokogiri
                    └── nokogiri.so
```

What really matters here is the `*.so` file, which is what we're trying to make here. Once that is
ready, you can copy it to its corresponding directory and zip it up as `*.tar.gz`, e.g.,

```
tar zcvf nokogiri-1.8.2.tar.gz 2.2.0
```

Alternatively, the Dockerfile provided in the directory will generate `nokogiri-1.8.2.tar.gz` and
store it into `/opt/build`. And we can use this tarball as an upgrade for what `Traveling Ruby`
provides.

Have fun!
