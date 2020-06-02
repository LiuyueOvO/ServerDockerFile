FROM centos:7
USER root

# Setup http proxy in case we are behind a firewall
ARG http_proxy
ENV http_proxy ${http_proxy}

# Install build tools
RUN yum install -y epel-release
RUN yum install -y wget unzip make cmake3 m4 gcc-c++ glibc.i686

# Install gcc
ENV LD_LIBRARY_PATH /usr/local/lib
RUN wget https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz \
    && tar xvfJ gmp-6.1.2.tar.xz \
    && cd gmp-6.1.2 && mkdir build && cd build && ../configure && make -j16 && make install

RUN wget https://www.mpfr.org/mpfr-4.0.1/mpfr-4.0.1.tar.xz \
    && tar xvfJ mpfr-4.0.1.tar.xz \
    && cd mpfr-4.0.1 && mkdir build && cd build && ../configure && make -j16 && make install

RUN wget http://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz \
    && tar xvfz mpc-1.1.0.tar.gz \
    && cd mpc-1.1.0 && mkdir build && cd build && ../configure && make -j16 && make install

RUN wget http://ftp.gnu.org/gnu/gcc/gcc-7.4.0/gcc-7.4.0.tar.xz \
    && tar xvfJ gcc-7.4.0.tar.xz \
    && cd gcc-7.4.0 && mkdir build && cd build && ../configure --disable-multilib && make -j16 && make install

RUN cp /usr/local/lib64/libstdc++.so.6.0.24 /lib64 \
    && rm /lib64/libstdc++.so.6 \
    && ln -s /lib64/libstdc++.so.6.0.24 /lib64/libstdc++.so.6 \
    && rm /usr/bin/cc && ln -s /usr/local/bin/gcc /usr/bin/cc \
    && rm /usr/bin/cpp && ln -s /usr/local/bin/g++ /usr/bin/cpp \
    && rm /usr/bin/c++ && ln -s /usr/local/bin/g++ /usr/bin/c++

# Install scm tools 
RUN yum install -y git svn
RUN yum install -y nmap-ncat

# Install dependencies
RUN yum install -y epel-release mysql-devel boost-devel log4cxx-devel jansson-devel jemalloc-devel

# For premake4 project
RUN (wget --timeout=5 --tries=3 https://qa.xindong.com/nexus/repository/raw/premake/premake-4.4-beta5-linux.tar.gz \
  || wget --timeout=5 --tries=3 http://sourceforge.net/projects/premake/files/Premake/4.4/premake-4.4-beta5-linux.tar.gz) \
    && tar xvfz premake-4.4-beta5-linux.tar.gz \
    && rm premake-4.4-beta5-linux.tar.gz \
    && mv premake4 /usr/local/bin

# Install dependencies
RUN wget https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
    && tar -xzvf v0.13.3.tar.gz \
    && cd hiredis-0.13.3 \
    && make -j16 && make install \
    && echo '/usr/local/lib' >>/etc/ld.so.conf \
    && ldconfig

# Download and install Lua
RUN wget http://www.lua.org/ftp/lua-5.3.5.tar.gz 
RUN tar zxf lua-5.3.5.tar.gz && rm lua-5.3.5.tar.gz
RUN cd lua-5.3.5 \
    && make -j16 linux CFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' CXXFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' \
    && make install \
    && cd .. \
    && rm -r lua-5.3.5

# Download and install luabind
# luabind was abandoned with many blocking issues. Here we use a fork.
RUN git clone https://github.com/Oberon00/luabind.git
RUN cd luabind \
    && mkdir build \
    && cd build \
    && export CFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' \
    && export CXXFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' \
    && cmake3 .. \
    && make -j16 \
    && make install \
    && cd ../.. \
    && rm -r luabind
RUN ln -s /usr/local/lib/libluabind09.a /usr/local/lib/libluabind.a

# Install redis cli
RUN wget http://download.redis.io/redis-stable.tar.gz \
    && tar xvzf redis-stable.tar.gz \
    && cd redis-stable \
    && make -j16 \
    && cp src/redis-cli /usr/bin/

# Install MySQL client
RUN wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm \
    && rpm -ivh mysql-community-release-el7-5.noarch.rpm \
    && yum update -y \
    && yum install -y mysql-community-client

# Download and install protobuf
RUN (wget --timeout=5 --tries=3 https://qa.xindong.com/nexus/repository/raw/protobuf/protobuf-cpp-3.0.0.tar.gz \
  || wget --timeout=5 --tries=3 https://github.com/protocolbuffers/protobuf/releases/download/v3.0.0/protobuf-cpp-3.0.0.tar.gz) \
    && tar xvfz protobuf-cpp-3.0.0.tar.gz \
    && rm protobuf-cpp-3.0.0.tar.gz \
    && cd protobuf-3.0.0 \
    && ./configure \
    && make -j16 CFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' CXXFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' \
    && make install \
    && cd .. \
    && rm -r protobuf-3.0.0

# Download and install gtest and gmock
RUN (wget --timeout=5 --tries=3 https://qa.xindong.com/nexus/repository/raw/googletest/googletest-release-1.8.1.tar.gz -O googletest-release-1.8.1.tar.gz \
  || wget --timeout=5 --tries=3 https://github.com/google/googletest/archive/release-1.8.1.tar.gz -O googletest-release-1.8.1.tar.gz) \
    && tar zxf googletest-release-1.8.1.tar.gz \
    && rm googletest-release-1.8.1.tar.gz \
    && cd googletest-release-1.8.1 \
    && BUILD_GMOCK=1 cmake3 . \
    && make -j16 CFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' CXXFLAGS='-g -O2 -w -D_GLIBCXX_USE_CXX11_ABI=0' \
    && make install \
    && cd .. \
    && rm -r googletest-release-1.8.1

# Workaround for some file using wrong include path. 
#RUN cp -r /usr/include/hiredis/* /usr/local/include/

# alias cmake3 as cmake
RUN ln -s /usr/bin/cmake3 /usr/bin/cmake

#add ENV
ENV LD_LIBRARY_PATH /usr/local/lib:/gcc-7.4.0/build/x86_64-pc-linux-gnu/libsanitizer/asan/.libs

ARG ws=/var/atelier-server
ENV WORKSPACE $ws

ARG script=./script
ADD $script/ /opt/script

# Set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Start 
WORKDIR $WORKSPACE
ENTRYPOINT ["/opt/script/start-service.sh"]
CMD ["start"]

