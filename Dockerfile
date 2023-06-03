FROM public.ecr.aws/lts/ubuntu:20.04_stable
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get --assume-yes \
            --no-install-recommends \
            install debootstrap \
                    debian-archive-keyring \
                    ca-certificates \
                    qemu-user-static \
                    qemu-system-arm \
                    qemu-system-x86 \
                    device-tree-compiler \
                    gcc \
                    gcc-arm-none-eabi \
                    make \
                    git \
                    bc \
                    bzip2 \
                    pigz \
                    bison \
                    flex \
                    python2-dev \
                    python3-dev \
                    python3-pkg-resources \
                    python3-setuptools \
                    swig \
                    parted \
                    e2fsprogs \
                    dosfstools \
                    mtools \
                    pwgen \
                    libssl-dev \
                    parallel \
                    ssh \
                    sshpass \
                    unzip && \
    ([ "$(uname -m)" = "aarch64" ] && \
     apt-get --assume-yes \
             install gcc-arm-linux-gnueabihf \
                     gcc-i686-linux-gnu \
                     gcc-x86-64-linux-gnu || :) && \
    ([ "$(uname -m)" = "x86_64" ] && \
     apt-get --assume-yes \
             install gcc-arm-linux-gnueabihf \
                     gcc-aarch64-linux-gnu \
                     gcc-i686-linux-gnu || :) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /var/log/*.log
RUN wget -q "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -O "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf aws
ENV PATH="/debimg/scripts:${PATH}"
COPY . /debimg
WORKDIR /debimg
