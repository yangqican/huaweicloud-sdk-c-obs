#!/bin/bash
echo =========== compile libxml2 ==================
open_src_path=`pwd`
if [ "NULL"${libxml2_version} = "NULL" ]; then
 libxml2_version=libxml2-2.9.9
fi
libxml2_dir=./../../../third_party_groupware/eSDK_Storage_Plugins/${libxml2_version}
libxml2_lib=`pwd`/build/${libxml2_version}/lib
libxml2_include=`pwd`/build/${libxml2_version}/include
static_libxml2_lib=`pwd`/build/${libxml2_version}/static_package/lib
cd $libxml2_dir
chmod 777 configure
autoreconf -f -i

if [ $# = 0 ]; then 
	if [ -z $BUILD_FOR_ARM ]; then
	./configure --prefix=/usr/local/libxml2 --with-threads --with-python=no
	elif [ $BUILD_FOR_ARM = "true" ]; then
	./configure --prefix=/usr/local/libxml2 --with-threads --host=aarch64-linux-gnu --build=aarch64-gnu-linux --with-gnu-ld --with-python=no
	fi
elif [ $1 = "BUILD_FOR_ARM" ]; then
    ./configure --prefix=/usr/local/libxml2 --with-threads --host=aarch64-linux-gnu --build=aarch64-gnu-linux --with-gnu-ld --with-python=no   
fi

make clean 
make
make install

cd $open_src_path
mkdir -p $libxml2_lib
mkdir -p $libxml2_include
mkdir -p $static_libxml2_lib
cp $libxml2_dir/.libs/libxml2.so*  $libxml2_lib
cp -rf $libxml2_dir/include/* $libxml2_include
cp /usr/local/libxml2/lib/*.a  $static_libxml2_lib

cd $open_src_path
