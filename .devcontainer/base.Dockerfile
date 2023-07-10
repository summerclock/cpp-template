FROM nvidia/cuda:12.2.0-devel-ubuntu22.04 as base

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update && apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  cmake \
  git \
  build-essential \
  libgflags-dev \
  libcli11-dev \
  libtbb-dev && \
  apt-get autoclean && apt-get clean

ADD third_party/glog-0.6.0.tar.gz /glog
RUN cd /glog && \
  cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" && \
  cmake --build build --config Release && cmake --build build --target install && \
  cd / && rm -rf glog

RUN apt-get update && apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libopencv-dev \
  libatlas-base-dev \
  libeigen3-dev \
  libsuitesparse-dev \
  libboost-program-options-dev \
  libboost-filesystem-dev \
  libboost-system-dev \
  libboost-iostreams-dev \
  libboost-serialization-dev \
  libcgal-dev \
  libgdal-dev && \
  apt-get autoclean && apt-get clean

FROM base AS dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  clang clangd lldb git valgrind cmake-format && \
  apt-get autoclean && apt-get clean

WORKDIR /root/repos/cpp-template
COPY . ./