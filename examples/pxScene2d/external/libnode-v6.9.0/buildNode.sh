./configure --shared
make -j$(getconf _NPROCESSORS_ONLN)
ln -sf out/Release/obj.target/libnode.so.48 libnode.so.48
ln -sf libnode.so.48 libnode.so
ln -sf out/Release/libnode.48.dylib libnode.48.dylib
ln -sf libnode.48.dylib libnode.dylib
