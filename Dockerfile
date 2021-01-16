# Native amd64
FROM debian:buster-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get --assume-yes \
            --no-install-recommends \
            install debootstrap \
                    debian-archive-keyring \
                    ubuntu-archive-keyring \
                    ca-certificates \
                    qemu-user-static \
                    device-tree-compiler \
                    gcc \
                    gcc-arm-none-eabi \
                    make \
                    git \
                    bc \
                    bzip2 \
                    bison \
                    flex \
                    python2-dev \
                    python3-dev \
                    python3-pkg-resources \
                    swig \
                    parted \
                    e2fsprogs \
                    dosfstools \
                    mtools \
                    pwgen \
                    libssl-dev && \
    ([ "$(uname -m)" = "x86_64" ] && \
     apt-get --assume-yes \
             install gcc-aarch64-linux-gnu \
                     gcc-arm-linux-gnueabihf) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/log/*.log
ENV PATH="/debimg/scripts:${PATH}"
COPY . /debimg
WORKDIR /debimg
