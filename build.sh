#!/bin/bash
#define constant variable
LINUX_ARMV7L=$PWD/../libs/linux-armv7l
LINUX_X86_64=$PWD/../libs/linux-x86_64
LINUX_I686=$PWD/../libs/linux-i686
MINGW=$PWD/../libs/mingw32-i586
MACOS=$PWD/../libs/darwin-x86_64
EXT=""
#MACOS
uname -a | grep "Darwin"
if [ $? == 0 ]; then
	INSTALL_DIR=$MACOS
	EXT="x86_64-apple-darwin12.5.0"
fi
#MINGW
uname -a | grep "MINGW32"
if [ $? == 0 ]; then
	INSTALL_DIR=$MINGW
	EXT="i586-pc-mingw32"
fi
#Linux
uname -a | grep "Linux"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$LINUX_I686
		EXT="i686-pc-linux-gnu"
	elif [ $ARCHITECTURE = "x86_64" ]; then
		INSTALL_DIR=$LINUX_X86_64
		EXT="x86_64-unknown-linux-gnu"
	fi
fi

#build for arm first
rm -rf $LINUX_ARMV7L/include/json-c
rm -rf $LINUX_ARMV7L/lib/libjson-c.*
make distclean
./autogen.sh
./configure --host=arm-linux-gnueabi --enable-shared=no --enable-static --prefix=$LINUX_ARMV7L
make
make install

#build for intel
rm -rf $INSTALL_DIR/include/json-c
rm -rf $INSTALL_DIR/lib/libjson-c.*
make distclean
./autogen.sh
./configure --prefix=$INSTALL_DIR
make
make install
