#!/bin/bash

# regarding export MACOSX_DEPLOYMENT_TARGET="10.4" in build_iOS, see reason why do it like this
# http://stackoverflow.com/questions/32622284/building-c-static-libraries-using-configure-make-with-fembed-bitcode-fails

ROOT=$(pwd)

##########################  ZIM  ##########################

# git clone https://gerrit.wikimedia.org/r/p/openzim.git
# modify ffstream.cpp, replace stat64 with stat

LZMAHEADERPATH="/Volumes/Data/Developer/Kiwix/Kiwix/libkiwix/include"

build_iOS()
{
	ARCH=$1
	
	if [ $ARCH == "i386" ] || [ $ARCH == "x86_64" ];
	then
		SDKROOT="$(xcodebuild -version -sdk iphonesimulator | grep -E '^Path' | sed 's/Path: //')"
	else
		SDKROOT="$(xcodebuild -version -sdk iphoneos | grep -E '^Path' | sed 's/Path: //')"
	fi

	export MACOSX_DEPLOYMENT_TARGET="10.4"

	export CC="$(xcrun -find clang)"
	export CFLAGS="-fembed-bitcode -isysroot $SDKROOT -arch ${ARCH} -miphoneos-version-min=9.0 -I$LZMAHEADERPATH"

	export CPP="$CC -E"
	export CPPFLAGS="$CFLAGS"

	export CXX="$(xcrun -find clang++)"
	export CXXFLAGS="$CFLAGS -stdlib=libc++ -std=c++11"

	export LDFLAGS="-arch ${ARCH} -isysroot $SDKROOT"

	if [ $ARCH == "i386" ] || [ $ARCH == "x86_64" ];
	then
		./configure --prefix=$(pwd)/build/iOS/$ARCH --host=i686-apple-darwin11 --enable-static --disable-shared
	else
		./configure --prefix=$(pwd)/build/iOS/$ARCH --host=arm-apple-darwin --enable-static --disable-shared
	fi

	make && make install && make clean
}

build_OSX()
{
	ARCH=$1
	
	SDKROOT="$(xcodebuild -version -sdk macosx10.11 | grep -E '^Path' | sed 's/Path: //')"

	export MACOSX_DEPLOYMENT_TARGET="10.10"
	
	export CC="$(xcrun -sdk macosx10.11 -find clang)"
	export CFLAGS="-fembed-bitcode -isysroot $SDKROOT -arch ${ARCH} -mmacosx-version-min=10.10 -I$LZMAHEADERPATH"

	export CXX="$(xcrun -sdk iphoneos -find clang++)"
	export CXXFLAGS="$CFLAGS -stdlib=libc++ -std=c++11"

	export LDFLAGS="-arch ${ARCH} -isysroot $SDKROOT"

	./configure --prefix=$(pwd)/build/OSX/$ARCH --host=i686-apple-darwin11 --disable-static --enable-shared

	make && make install && make clean
}

distribute_iOS() {
	iOSBUILDDir=$(pwd)/build/iOS
	cd $iOSBUILDDir
	mkdir -p universal/lib

	cd armv7/lib
	for file in *.a
	do
		cd $iOSBUILDDir
		lipo -create armv7/lib/$file armv7s/lib/$file arm64/lib/$file x86_64/lib/$file i386/lib/$file -output universal/lib/$file
	done

	# cd armv7/lib
	# for file in *.dylib
	# do
	# 	cd $iOSBUILDDir
	# 	lipo -create armv7/lib/$file armv7s/lib/$file arm64/lib/$file x86_64/lib/$file i386/lib/$file -output universal/lib/$file
	# done

	cp -r armv7/include universal
}

distribute() {
	cd $ZIMREADERPATH/build
	mkdir -p Universal/iOS/lib
	mkdir -p Universal/OSX/lib

	# cd iOS/armv7/lib
	# for file in *.a
	# do
	# 	cd $ZIMREADERPATH/build
	# 	lipo -create iOS/armv7/lib/$file iOS/armv7s/lib/$file iOS/arm64/lib/$file iOS/x86_64/lib/$file iOS/i386/lib/$file -output Universal/iOS/lib/$file
	# done

	cd OSX/i386/lib
	for file in *.dylib
	do
		cd $ZIMREADERPATH/build
		lipo -create OSX/x86_64/lib/$file OSX/i386/lib/$file -output Universal/OSX/lib/$file
	done
	
	# cd $ZIMREADERPATH/build
	# mkdir -p Universal/include
	# cp -r iOS/armv7/include Universal
}

# build_iOS i386
# build_iOS x86_64
# build_iOS armv7
# build_iOS armv7s
# build_iOS arm64
distribute_iOS

# build_OSX i386
# build_OSX x86_64

# distribute

