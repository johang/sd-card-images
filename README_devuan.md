# Devuan SD card images

This repository is a bunch of scripts to build SD card images that various [single-board computers](https://en.wikipedia.org/wiki/Single-board_computer) (SBC) can boot. Emphasis is on pureness; pure Debian and pure mainline U-boot.

## Pre-built images

Pre-built images ready for download are availble at [sd-card-images.johang.se](https://sd-card-images.johang.se).

## Usage

The generated SD card images are made up of two separate images:

- **boot-BOARD.bin**: Boot image that contains partition table, U-Boot and chip-specific code. The boot image will only work on the board it's built for. The filename indicates which board it's built for.
- **debian-ARCH-VERSION-PASSWORD.bin**: Debian ext4 root filesystem image that contains a complete Debian installation, including kernel, initrd and device tree. This Debian image is generic and will work on all chips and boards with the CPU architecture it's built for. The filename indicates Debian version, CPU architecture and default root password.

These two images are the concatenated to a single image, which is then written to SD card, for example like this:

    $ zcat boot-raspberrypi_3b.bin.gz debian-buster-arm64-XXXXXX.bin.gz > sd-card.img
    # dd if=sd-card.img of=/dev/sdXXX

### Build your own Devuan boot image

#### To build a boot image for Raspberry Pi 3 B:

```bash
docker build -t devuan/sd-images -f Dockerfile.devuan https://github.com/watchful-0wl/sd-card-images.git#add_devuan
mkdir -p /tmp/sd-images
docker run --rm -v /tmp/sd-images:/artifacts sd-images build-boot raspberrypi_3b bcm2837 rpi_3_defconfig aarch64-linux-gnu
```

The image will end up in /tmp/sd-images on the host.

#### To build a boot image for Pine64 Rockpro64:

```bash
docker build -t devuan/sd-images -f Dockerfile.devuan https://github.com/watchful-0wl/sd-card-images.git#add_devuan
mkdir -p /tmp/sd-images
docker run --rm \
  -v /tmp/sd-images:/artifacts \
  devuan/sd-images \
  build-boot ROCKPro64 rk3399 rockpro64-rk3399_defconfig aarch64-linux-gnu
```

The image will end up in /tmp/sd-images on the host.

#### To build a boot image for Sinovoip Banana Pi M2 Zero

```bash
docker build -t devuan/sd-images -f Dockerfile.devuan https://github.com/watchful-0wl/sd-card-images.git#add_devuan
mkdir -p /tmp/sd-images
docker run --rm \
  -v /tmp/sd-images:/artifacts \
  devuan/sd-images \
  build-boot banana_pi_m2_zero allwinner-h2+ bananapi_m2_zero_defconfig arm-linux-gnueabihf
```

The image will end up in /tmp/sd-images on the host.

### Build your own Debian ext4 root filesystem image

#### To build a Devuan ext4 root filesystem image for arm64:

```bash
docker build -t devuan/sd-images -f Dockerfile.devuan https://github.com/watchful-0wl/sd-card-images.git#add_devuan
mkdir -p /tmp/sd-images
docker run --rm \
  -v /tmp/sd-images:/artifacts \
  --privileged \
  devuan/sd-images \
  build-debian devuan arm64 daedalus
```

The image will end up in /tmp/sd-images on the host.

#### To build a Devuan ext4 root filesystem image for armhf:

```bash
docker build -t devuan/sd-images -f Dockerfile.devuan https://github.com/watchful-0wl/sd-card-images.git#add_devuan
mkdir -p /tmp/sd-images
docker run --rm \
  -v /tmp/sd-images:/artifacts \
  --privileged \
  devuan/sd-images \
  build-debian devuan armhf daedalus
```

The image will end up in /tmp/sd-images on the host.
