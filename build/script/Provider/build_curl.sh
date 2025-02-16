#!/bin/bash
echo =========== compile curl ==================
open_src_path=`pwd`
if [ "NULL"${curl_version} = "NULL" ]; then
   curl_version=curl-7.64.1
fi
curl_dir=./../../../third_party_groupware/eSDK_Storage_Plugins/${curl_version}
curl_lib=`pwd`/build/${curl_version}/lib
curl_include=`pwd`/build/${curl_version}/include/curl
static_curl_lib=`pwd`/build/${curl_version}/static_package/lib

nghttp2_dir=/usr/local/nghttp2/lib
rm -rf  $nghttp2_dir/libnghttp2.so $nghttp2_dir/libnghttp2.so.14

cd $curl_dir
chmod 777 configure

if [ $# = 0 ]; then 
	if [ -z $BUILD_FOR_ARM ]; then
	./configure --prefix=/usr/local/curl --with-ssl=/usr/local/openssl --with-nghttp2=/usr/local/nghttp2
	lib_out="linux_x64"
	elif [ $BUILD_FOR_ARM = "true" ]; then
	./configure --prefix=/usr/local/curl --with-ssl=/usr/local/openssl --host=aarch64-linux-gnu --build=aarch64-gnu-linux --with-gnu-ld
	lib_out="aarch64"
	fi
elif [ $1 = "BUILD_FOR_ARM" ]; then
./configure --prefix=/usr/local/curl --with-ssl=/usr/local/openssl --host=aarch64-linux-gnu --build=aarch64-gnu-linux --with-gnu-ld
lib_out="aarch64"
fi

ln -s /usr/local/nghttp2/lib/libnghttp2.so.14.16.2 /usr/local/nghttp2/lib/libnghttp2.so
ln -s /usr/local/nghttp2/lib/libnghttp2.so.14.16.2 /usr/local/nghttp2/lib/libnghttp2.so.14

make clean 
make
make install

cd $open_src_path
mkdir -p $curl_lib
mkdir -p $curl_include
mkdir -p $static_curl_lib

cp $open_src_path/$curl_dir/lib/.libs/libcurl.so*  $curl_lib
cp $open_src_path/$curl_dir/include/curl/*.h $curl_include
cp $open_src_path/$curl_dir/lib/.libs/*.a  $static_curl_lib

cd $open_src_path
