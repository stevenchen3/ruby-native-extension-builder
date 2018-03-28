#!/bin/bash

set -ex

EXT_DIR=2.2.0/extensions/x86_64-linux/2.2.0-static
TARGET_DIR=/opt/build/target
BUNDLE_INSTALL_DIR=/opt/build/vendor/bundle

mkdir -p ${TARGET_DIR}
bundle install --path ${BUNDLE_INSTALL_DIR}
cd ${BUNDLE_INSTALL_DIR}/ruby

GEMS=$(ls "${EXT_DIR}")

for gem in $GEMS; do
  tar zcvf ${gem}.tar.gz ${EXT_DIR}/${gem}
  mv ${gem}.tar.gz ${TARGET_DIR}
done
