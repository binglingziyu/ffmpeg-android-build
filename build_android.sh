#!/usr/bin/env bash

# current host
export HOST_TAG=darwin-x86_64

# export ARCH=aarch64
# export CPU=armv8-a
export ARCH=armv7a
export CPU=armv7-a
# Min Android Version
export MIN=21

export PREFIX=$(pwd)/android/$CPU
# NDK root
export NDK=/Users/staff/Application/ndk/android-ndk-r20

export MIN_PLATFORM=$NDK/platforms/android-$MIN
export SYSROOT=$NDK/sysroot
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as
export CC=$TOOLCHAIN/bin/$ARCH-linux-androideabi$MIN-clang
export CXX=$TOOLCHAIN/bin/$ARCH-linux-androideabi$MIN-clang++
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip

OPTIMIZE_CFLAGS="-I$NDK/sysroot/usr/include -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
ADDI_LDFLAGS="-shared -rpath-link=$SYSROOT/usr/lib/aarch64-linux-android -L$SYSROOT/usr/lib/aarch64-linux-android -fuse-ld=bfd"

sed  -i "" "s/SLIBNAME_WITH_MAJOR='\$(SLIBNAME).\$(LIBMAJOR)'/SLIBNAME_WITH_MAJOR='\$(SLIBPREF)\$(FULLNAME)-\$(LIBMAJOR)\$(SLIBSUF)'/" configure
sed  -i "" "s/LIB_INSTALL_EXTRA_CMD='\$\$(RANLIB) \"\$(LIBDIR)\\/\$(LIBNAME)\"'/LIB_INSTALL_EXTRA_CMD='\$\$(RANLIB) \"\$(LIBDIR)\\/\$(LIBNAME)\"'/" configure
sed  -i "" "s/SLIB_INSTALL_NAME='\$(SLIBNAME_WITH_VERSION)'/SLIB_INSTALL_NAME='\$(SLIBNAME_WITH_MAJOR)'/" configure
sed  -i "" "s/SLIB_INSTALL_LINKS='\$(SLIBNAME_WITH_MAJOR) \$(SLIBNAME)'/SLIB_INSTALL_LINKS='\$(SLIBNAME)'/" configure
sed  -i "" "s/SHFLAGS='-shared -Wl,-soname,\$(SLIBNAME)'/SHFLAGS='-shared -soname \$(SLIBNAME)'/" configure
# sed  -i "" "s/-Wl//g" configure

./configure \
--prefix=$PREFIX \
--ar=$AR \
--as=$AS \
--cc=$CC \
--cxx=$CXX \
--ld=$LD \
--nm=$NM \
--ranlib=$RANLIB \
--strip=$STRIP \
--arch=$ARCH \
--target-os=android \
--enable-cross-compile \
--disable-asm \
--enable-shared \
--disable-static \
--disable-ffprobe \
--disable-ffplay \
--disable-ffmpeg \
--disable-debug \
--disable-symver \
--disable-stripping \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS"

sed  -i "" "s/#define HAVE_TRUNC 0/#define HAVE_TRUNC 1/" config.h
sed  -i "" "s/#define HAVE_TRUNCF 0/#define HAVE_TRUNCF 1/" config.h
sed  -i "" "s/#define HAVE_RINT 0/#define HAVE_RINT 1/" config.h
sed  -i "" "s/#define HAVE_LRINT 0/#define HAVE_LRINT 1/" config.h
sed  -i "" "s/#define HAVE_LRINTF 0/#define HAVE_LRINTF 1/" config.h
sed  -i "" "s/#define HAVE_ROUND 0/#define HAVE_ROUND 1/" config.h
sed  -i "" "s/#define HAVE_ROUNDF 0/#define HAVE_ROUNDF 1/" config.h
sed  -i "" "s/#define HAVE_CBRT 0/#define HAVE_CBRT 1/" config.h
sed  -i "" "s/#define HAVE_CBRTF 0/#define HAVE_CBRTF 1/" config.h
sed  -i "" "s/#define HAVE_COPYSIGN 0/#define HAVE_COPYSIGN 1/" config.h
sed  -i "" "s/#define HAVE_ERF 0/#define HAVE_ERF 1/" config.h
sed  -i "" "s/#define HAVE_HYPOT 0/#define HAVE_HYPOT 1/" config.h
sed  -i "" "s/#define HAVE_ISNAN 0/#define HAVE_ISNAN 1/" config.h
sed  -i "" "s/#define HAVE_ISFINITE 0/#define HAVE_ISFINITE 1/" config.h
sed  -i "" "s/#define HAVE_INET_ATON 0/#define HAVE_INET_ATON 1/" config.h
sed  -i "" "s/#define getenv(x) NULL/\\/\\/ #define getenv(x) NULL/" config.h
