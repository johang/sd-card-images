HOW TO CHANGE ROOT PASSWORD
---------------------------

1. It is strongly recommended that you change the root password:

# passwd root

HOW TO RESIZE ROOT FILESYSTEM PARTITION
---------------------------------------

1. Maximize size of rootfs partition in:

# parted -s /dev/mmcblk0 resizepart -- 2 -1

2. Reload partition table:

# partprobe

3. Expand ext4 filesystem:

# resize2fs /dev/mmcblk0p2
