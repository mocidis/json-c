#!/bin/bash
if [ $# -lt 1 ]; then
echo "
Usage:
    ./build.sh [0|1]
        0: don't do cross compile for arm
        1: do cross compile for arm
"
exit
fi
#define constant variable
LINUX_ARMV7L=$PWD/../libs/linux-armv7l
LINUX_X86_64=$PWD/../libs/linux-x86_64
LINUX_I686=$PWD/../libs/linux-i686
MINGW=$PWD/../libs/mingw32-i586
MACOS=$PWD/../libs/darwin-x86_64
MSYS=$PWD/../libs/msys-i686
ARM=$1
#MACOS
uname -a | grep "Darwin"
if [ $? == 0 ]; then
	INSTALL_DIR=$MACOS
fi
#MINGW
uname -a | grep "MINGW32"
if [ $? == 0 ]; then
	INSTALL_DIR=$MINGW
fi
#MSYS
uname -a | grep "MSYS"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$MSYS
	fi
fi
#Linux
uname -a | grep "Linux"
if [ $? == 0 ]; then
	ARCHITECTURE=`uname -m`
	if [ $ARCHITECTURE = "i686" ]; then
		INSTALL_DIR=$LINUX_I686
	elif [ $ARCHITECTURE = "x86_64" ]; then
		INSTALL_DIR=$LINUX_X86_64
	fi
fi

if [ $ARM == 1 ]; then
	#build for arm first
	rm -rf $LINUX_ARMV7L/include/json-c
	rm -rf $LINUX_ARMV7L/lib/libjson-c.*
	make distclean
	./autogen.sh
	./configure --host=arm-linux-gnueabi --enable-shared=no --enable-static --prefix=$LINUX_ARMV7L
	make
	make install
fi

#build for intel
rm -rf $INSTALL_DIR/include/json-c
rm -rf $INSTALL_DIR/lib/libjson-c.*
make distclean
./autogen.sh
./configure --enable-shared=no --enable-static --prefix=$INSTALL_DIR
make
make install
