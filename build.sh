#!/bin/bash

# Path to build your kernel
  k=~/Documents/HelixKernel_EAS
# Directory for the any kernel updater
  t=$k/packages
# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
#   echo "Clean"
#     rm -rf $k/out
#     make clean

# Setup the build
 cd $k/arch/arm64/configs/placeholder
    for c in *
      do
        cd $k
# Setup output directory
    mkdir -p "out/$c"
    cp -R "$t/modules" out/$c
    cp -R "$t/system" out/$c
    cp -R "$t/META-INF" out/$c
    cp -R "$t/patch" out/$c
    cp -R "$t/ramdisk" out/$c
    cp -R "$t/tools" out/$c
    cp -R "$t/anykernel.sh" out/$c

  m=$k/out/$c/modules
  z=$c-$today

TOOLCHAIN=/home/augustine/Android/Sdk/ndk-bundle/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64

# make mrproper
#make CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper
 
# remove backup files
#find ./ -name '*~' | xargs rm
# rm compile.log

# make kernel

make ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN O=out msm_defconfig
make ARCH=arm64 CROSS_COMPILE=$TOOLCHAIN O=out -j`grep 'processor' /proc/cpuinfo | wc -l`

# Grab zImage-dtb
   echo ""
   echo "<<>><<>>  Collecting Image.gz-dtb <<>><<>>"
   echo ""
   cp $k/out/arch/arm64/boot/Image.gz-dtb out/$c/Image.gz-dtb
   echo ""
   echo "<<>><<>>  Collecting modules <<>><<>>"
   echo ""
   for mo in $(find . -name "*.ko"); do
		cp "${mo}" $m
   done
   
# Build Zip
 clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a -tzip -mx5 "$z.zip"
         mv $z.zip $k/out/$z.zip
# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
      done
