FROM debian:latest
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install debootstrap \
                       debian-archive-keyring \
                       git \
                       crossbuild-essential-arm64 \
                       crossbuild-essential-armhf \
                       qemu-user-static \
                       device-tree-compiler \
                       bison \
                       flex \
                       python-dev \
                       swig \
                       parted \
                       e2fsprogs \
                       pwgen
ENV PATH="/debimg:${PATH}"
COPY . /debimg
WORKDIR /debimg
