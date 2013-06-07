inherit image_types

# Some default variables nedded for the following functions to work
IMAGE_BOOTLOADER ?= "u-boot"
SDCARD_ROOTFS ?= "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.ext3"
UBOOT_PADDING ?= "0"
UBOOT_SUFFIX ?= "sb"
UBOOT_SUFFIX_SDCARD ?= "${UBOOT_SUFFIX}"

# Boot partition volume id
BOOTDD_VOLUME_ID ?= "Boot ${MACHINE}"

# Boot partition size [in KiB]
BOOT_SPACE ?= "8192"

# Set alignment to 4MB [in KiB]
IMAGE_ROOTFS_ALIGNMENT = "4096"

IMAGE_DEPENDS_sdcard = "parted-native dosfstools-native mtools-native \
                        u-boot-mxsboot-native virtual/kernel \
                        ${IMAGE_BOOTLOADER}"

SDCARD = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.sdcard"

#
# Create an image that can by written onto a SD card using dd for use
# with i.MXS SoC family
#
# External variables needed:
#   ${SDCARD_ROOTFS}    - the rootfs image to incorporate
#   ${IMAGE_BOOTLOADER} - bootloader to use {imx-bootlets, u-boot}
#
generate_sdcard () {
    # The disk layout used is:
    #
    #    1M - 2M                  - reserved to bootloader and other data
    #    2M - BOOT_SPACE          - kernel
    #    BOOT_SPACE - SDCARD_SIZE - rootfs
    #

    # Create a partition table
    parted -s ${SDCARD} mklabel msdos

    # Create a partition for the u-boot
    parted -s ${SDCARD} unit KiB mkpart primary 1024 2048

    # Create a partition for the Linux kernel and DTB stuff.
    parted -s ${SDCARD} unit KiB mkpart primary 2048 \
        $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED})

    # Create a partition for the RootFS
    parted -s ${SDCARD} unit KiB mkpart primary \
        $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED}) \
        $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ \
          $ROOTFS_SIZE)

    # Create a bootable u-boot image
    mxsboot sd ${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} \
        ${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.mxsboot-sdcard

    # Write the u-boot image to the sdcard image
    dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.mxsboot-sdcard of=${SDCARD} \
        conv=notrunc seek=1 skip=${UBOOT_PADDING} bs=$(expr 1024 \* 1024)

    # Create an vfat image, pupulate it with the kernel and, eventually,
    # with the devicetree binary and finally write it to the sdcard.
    BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
        | awk '/ 2 / { print substr($4, 1, length($4 -1)) / 1024 }')

    mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 \
        -C ${WORKDIR}/boot.img $BOOT_BLOCKS

    mcopy -i ${WORKDIR}/boot.img \
        -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin \
        ::/${KERNEL_IMAGETYPE}

    if test -n "${KERNEL_DEVICETREE}"; then
        for DTS_FILE in ${KERNEL_DEVICETREE}; do

            DTS_BASE_NAME=`basename ${DTS_FILE} | awk -F "." '{print $1}'`

            if [ -e "${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}.dtb" ]; then

                kernel_bin="`readlink ${KERNEL_IMAGETYPE}-${MACHINE}.bin`"
                kernel_bin_for_dtb="`readlink \
                    ${KERNEL_IMAGETYPE}-${DTS_BASE_NAME}.dtb \
                    | sed "s,$DTS_BASE_NAME,${MACHINE},g;s,\.dtb$,.bin,g"`"

                if [ $kernel_bin = $kernel_bin_for_dtb ]; then

                    DTB_NAME=${DEPLOY_DIR_IMAGE}
                    DTB_NAME=${DTB_NAME}/${KERNEL_IMAGETYPE}
                    DTB_NAME=${DTB_NAME}-${DTS_BASE_NAME}.dtb

                    mcopy -i ${WORKDIR}/boot.img -s ${DTB_NAME} \
                        ::/${DTS_BASE_NAME}.dtb
                fi
            fi
        done
    fi

    dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc seek=2 \
        bs=$(expr 1024 \* 1024)

    # Change partition type for mxs processor family
    bbnote "Setting partition type to 0x53 as required for mxs' SoC family."
    echo -n S | dd of=${SDCARD} bs=1 count=1 seek=450 conv=notrunc

    parted ${SDCARD} print

    BLOCK_SIZE=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + \
        ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)

    dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc \
        seek=1 bs=${BLOCK_SIZE} && sync && sync
}

IMAGE_CMD_sdcard () {
    if [ -z "${SDCARD_ROOTFS}" ]; then
        bberror "SDCARD_ROOTFS is undefined!"
        exit 1
    fi

    # Align boot partition and calculate total SD card image size
    BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
    BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} \
        % ${IMAGE_ROOTFS_ALIGNMENT})
    SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + \
        $ROOTFS_SIZE + ${IMAGE_ROOTFS_ALIGNMENT})

    # Initialize a sparse file
    dd if=/dev/zero of=${SDCARD} bs=1 count=0 \
        seek=$(expr 1024 \* ${SDCARD_SIZE})

    generate_sdcard
}
