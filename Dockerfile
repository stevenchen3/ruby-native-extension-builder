FROM centos:centos6


ADD ./Gemfile  /opt/build/
ADD ./build.sh /opt/build/

RUN \
  yum update -y && \
  yum groupinstall -y 'Development Tools' && \
  yum install -y openssl-devel wget tar && \
  cd /opt && \
  wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz && \
  tar xvfz ruby-2.2.2.tar.gz && \
  cd ruby-2.2.2 && \
  ./configure && \
  make && make install

RUN \
  gem update --system && \
  cd /opt/build && \
  /bin/bash build.sh
