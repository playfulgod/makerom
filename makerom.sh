#!/bin/bash

################################################################################
# Create VS910 ROM given CM9 update zip and valid VS910 boot update.zip
################################################################################
# Authored by Andy I. Christianson @ 2012-01-08
# Released to public under MIT license
################################################################################

set -e
set -x

# define general values
pushd "$(dirname $0)"
BASE_DIR="$(pwd)"
popd
RESOURCES_DIR="${BASE_DIR}/resources"

OUT_DIR="$(cd ${BASE_DIR}/.. && pwd)"
BUILD_ID="${RANDOM}"
OUT_FILE_NAME="cm9_vs910-ota-eng.${USER}.${BUILD_ID}.zip"
OUT_FILE_NAME_LIBS="cm9_vs910-ota-eng.libs.${USER}.${BUILD_ID}.zip"

# define CM9-related values
CM9_SYSTEM_SRC_PATH="${BASE_DIR}/../cm9/system"
CM9_OUT_PATH="${CM9_SYSTEM_SRC_PATH}/out/target/product/vs910"

# define VS910 boot update.zip values
VS910_BOOT_UPDATE_ZIP_PATH="${BASE_DIR}/../bk1.0/update.working.0.zip"
VS919_EXTRACTED_WORKING_ROM_PATH="${BASE_DIR}/../gv1.3"
VS910_KERNEL="${BASE_DIR}/../VS910/kernel/arch/arm/boot/zImage"

# define working environment
WORKING_DIR="$(mktemp -d '/tmp/makerom.XXXXXXXXXXXXXXXX')"
cd "${WORKING_DIR}"

# prepare system
mkdir rom-extracted
cd rom-extracted
unzip "${CM9_OUT_PATH}"/cm_vs910-ota-eng.*.zip
cat "${RESOURCES_DIR}/updater-script" >"$(find . -name updater-script)"

cd "${WORKING_DIR}"

# prepare boot
mkdir boot-extracted
cd boot-extracted
unzip "${VS910_BOOT_UPDATE_ZIP_PATH}"

mkdir bootimg
cd bootimg
rsync -vr "${RESOURCES_DIR}/bootimg-tools/" ./
cp ../boot.img ./
./extractboot boot.img
cp -f "${RESOURCES_DIR}/init.rc" out/ramdisk/

# replace kernel
cp -f "${VS910_KERNEL}" boot.img-kernel

./packboot
mv -f boot_new.img "${WORKING_DIR}/rom-extracted/boot.img"

rsync -vr "${WORKING_DIR}/boot-extracted/system/" "${WORKING_DIR}/rom-extracted/system/"

# overlay EGL/GLES libraries
cd "${WORKING_DIR}/rom-extracted"
#rm -rf system/lib/egl/*
#rsync -vr "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/egl/" system/lib/egl/

rsync -vr "${RESOURCES_DIR}/adreno200/" system/lib/egl/

cp -f "${RESOURCES_DIR}/libgsl.so" system/lib/libgsl.so
#cp -f "${RESOURCES_DIR}/libgenlock.so" system/lib/libgenlock.so

#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/egl/egl.cfg" system/lib/egl/egl.cfg
#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/egl/libEGL_adreno200.so" system/lib/egl/libEGL_adreno200.so
#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/egl/libGLESv1_CM_adreno200.so" system/lib/egl/libGLESv1_CM_adreno200.so
#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/egl/libGLESv2_adreno200.so" system/lib/egl/libGLESv2_adreno200.so

#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/libEGL.so" system/lib/libEGL.so
#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/libGLESv1_CM.so" system/lib/libGLESv1_CM.so
#cp -f "${VS919_EXTRACTED_WORKING_ROM_PATH}/system/lib/libGLESv2.so" system/lib/libGLESv2.so

# zip rom
cd "${WORKING_DIR}/rom-extracted"

zip -r ${OUT_DIR}/${OUT_FILE_NAME} *

# create system/lib update rom
find system -mindepth 1 -maxdepth 1 -not -name lib | xargs rm -rf
rm boot.img
cat "${RESOURCES_DIR}/updater-script-libs" >"$(find . -name updater-script)"
zip -r ${OUT_DIR}/${OUT_FILE_NAME_LIBS} *

# clean up
echo "Cleaning up"
rm -rf "${WORKING_DIR}"

# done
echo "Done. Output ROM is at ${OUT_DIR}/${OUT_FILE_NAME}"
