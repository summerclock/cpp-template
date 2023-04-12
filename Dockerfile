FROM ubuntu:22.04 AS base

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

FROM base AS release

WORKDIR /root/repos/cpp-template
COPY . ./

RUN mkdir -p build && cd build && \
  cmake -DCMAKE_INSTALL_PREFIX="/opt" -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=g++ -S/root/repos/cpp-template -B/root/repos/cpp-template/build -G "Unix Makefiles" && \
  cmake --build /root/repos/cpp-template/build --config Release --target all -j 18 && cmake --build . --target install --config Release && \
  cd / && rm -rf /root/repos

ENV PATH $PATH:/opt/bin
WORKDIR /opt/bin

FROM base AS dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  clang clangd lldb git valgrind cmake-format && \
  apt-get autoclean && apt-get clean

WORKDIR /root/repos/cpp-template
COPY . ./