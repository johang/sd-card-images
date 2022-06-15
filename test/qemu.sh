#!/bin/bash
# Boot up and shutdown

BOOT="${1:-boot-qemu_aarch64_virt.bin.gz}"
DEBIAN="${2:-debian-bullseye-arm64-XXXXXX.bin.gz}"

set -ex

# Parse out stuff
IFS="-." read -a PARTS1 <<< `basename "${BOOT}"`
BOARD="${PARTS1[1]}"
echo "Using board ${BOARD}"

# Parse out stuff
IFS="-." read -a PARTS2 <<< `basename "${DEBIAN}"`
ARCH="${PARTS2[2]}"
SSHPASS="${PARTS2[3]}"
echo "Using password ${SSHPASS}"

# Build image
zcat "${BOOT}" "${DEBIAN}" > image.bin

# Assume 4GB virtual disk
fallocate -l 4GB image.bin

# Extract U-Boot (u-boot.rom in x86 case)
dd if=image.bin of=bios.bin count=2048 skip=16

case "${BOARD}" in
qemu*)
	;;
*)
	echo "Unsupported \$BOARD: ${BOARD}"
	exit 1
	;;
esac

case "${ARCH}" in
amd64)
	QEMU_ARCH="x86_64"
	QEMU_MACHINE="pc"
	QEMU_CPU="qemu64"
	;;
i386)
	QEMU_ARCH="i386"
	QEMU_MACHINE="pc"
	QEMU_CPU="qemu32"
	;;
arm64)
	QEMU_ARCH="aarch64"
	QEMU_MACHINE="virt"
	QEMU_CPU="cortex-a53"
	;;
armhf)
	QEMU_ARCH="arm"
	QEMU_MACHINE="virt"
	QEMU_CPU="cortex-a15"
	;;
*)
	echo "Unknown \$ARCH: ${ARCH}"
	exit 1
	;;
esac

# Launch QEMU with U-Boot and image
qemu-system-${QEMU_ARCH} -machine ${QEMU_MACHINE} \
                         -cpu ${QEMU_CPU} \
                         -m 512 \
                         -bios bios.bin \
                         -serial stdio \
                         -no-reboot \
                         -display none \
                         -drive file=image.bin,format=raw,media=disk \
                         -nic user,hostfwd=tcp:127.0.0.1:5555-:22 &

sleep 15

# Pass password to sshpass
export SSHPASS

# SSH into QEMU and shut it down
until sshpass -e ssh -o "ConnectTimeout=5" \
                     -o "StrictHostKeyChecking=no" \
                     -o "UserKnownHostsFile=/dev/null" \
                     -p 5555 \
                     -q \
                     root@localhost "sleep 5 && apt-get update && poweroff"; do
	sleep 1
done

# Wait for QEMU to exit
wait
