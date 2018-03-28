FROM centos:centos6


ADD ./Gemfile /opt/build/

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
  bundle install --path vendor/bundle && \
  cd vendor/bundle/ruby && \
  tar zcvf nokogiri-1.8.2.tar.gz 2.2.0/extensions/x86_64-linux/2.2.0-static/nokogiri-1.8.2 && \
  mv nokogiri-1.8.2.tar.gz /opt/build && \
  cd -
