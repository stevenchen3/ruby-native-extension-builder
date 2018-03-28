# Building Ruby gem native extensions

Some Ruby gems depend on C/C++ native extensions which are platform dependent. `nokogiri` is one of
these. Fortunately, [Traveling Ruby](https://github.com/phusion/traveling-ruby) provides a solution
to include native extensions for several specific platforms. However, those extensions provided by
Traveling Ruby are quite obsolete and it is quite non-trivial to build those packages using
Traveling Ruby. I encountered failures with `yum update` in the `chroot` environment every now and
then. Thus, I would rather build it on my own.

As a workaround, we can build specific library in `centos:centos6` container and copy those
extensions after the build. Note that the final artifact of an extension should contain the
following (use `nokogiri` as an example), which can be found at your bundle `--path`:

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
store it into `/opt/build/target`. And we can use this tarball as an upgrade for what `Traveling Ruby`
provides. To build native extensions for more gems, add those gem into `Gemfile`, and run the
following:

```
$ docker build -t rubygem-native-builder .
$ docker cp rubygem-native-builder:/opt/build/target /path/to/host/directory
```

Currently, it only builds native extensions for `x86_64` Linux. Have fun!
