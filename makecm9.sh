#!/bin/bash

################################################################################
# builds full CM9 rom to be patched by makerom.sh
################################################################################

BASE_DIR="$(cd $(dirname $0) && pwd)"
CM9_PATH="${BASE_DIR}/../cm9/system"

cd "${CM9_PATH}"

export USE_CCACHE=1
export CCACHE_DIR=~/host/ccache
./prebuilt/linux-x86/ccache/ccache -M 100G
. ./build/envsetup.sh
make clean
breakfast vs910
make bacon -j2
