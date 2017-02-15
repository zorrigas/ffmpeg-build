#!/bin/bash
# Easy 1 click build - https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
# La paja de copiar y pegar me ganó xD

# Install tools to make
yum install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel openssl-devel

# Install make dir for all sources, you can keep for updates
mkdir /usr/local/src/ffmpeg_sources

# Install Yasm
cd /usr/local/src/ffmpeg_sources
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="/usr/local/src/ffmpeg_build" --bindir="/usr/local/bin"
make
make install
make distclean

# Install x264
cd /usr/local/src/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="/usr/local/src/ffmpeg_build/lib/pkgconfig" ./configure --prefix="/usr/local/src/ffmpeg_build" --bindir="/usr/local/bin" --enable-static
make
make install
make distclean

# Install x265
cd /usr/local/src/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd /usr/local/src/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local/src/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install

# Install AAC
cd /usr/local/src/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-shared
make
make install
make distclean

# Install LAME
cd /usr/local/src/ffmpeg_sources
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="/usr/local/src/ffmpeg_build" --bindir="/usr/local/bin" --disable-shared --enable-nasm
make
make install
make distclean

# Install Opus
cd /usr/local/src/ffmpeg_sources
git clone http://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-shared
make
make install
make distclean

# Install libOGG
cd /usr/local/src/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-shared
make
make install
make distclean

# Install libVorbis
cd /usr/local/src/ffmpeg_sources
curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xzvf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
LDFLAGS="-L/usr/local/src/ffmpeg_build/lib" CPPFLAGS="-I/usr/local/src/ffmpeg_build/include" ./configure --prefix="/usr/local/src/ffmpeg_build" --with-ogg="/usr/local/src/ffmpeg_build" --disable-shared
make
make install
make distclean

# Install libVPX
cd /usr/local/src/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="/usr/local/src/ffmpeg_build" --disable-examples
make
make install
make clean

# Install FFMPEG
cd /usr/local/src/ffmpeg_sources
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="/usr/local/src/ffmpeg_build/lib/pkgconfig" ./configure --prefix="/usr/local/src/ffmpeg_build" --extra-cflags="-I/usr/local/src/ffmpeg_build/include" --extra-ldflags="-L/usr/local/src/ffmpeg_build/lib" --bindir="/usr/local/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-openssl
make
make install
make distclean
hash -r

# Finish ;D
