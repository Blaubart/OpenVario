inherit image_types
require VERSION.inc

# Create an image that can by written onto a SD card using dd.
# Originally written for rasberrypi adapt for the needs of allwinner sunxi based boards
#
# The disk layout used is:
#-------------------------
# 0x12345678
# 0x00000000                0          -> 8*1024                           - reserverd
# 0x00002000           8*1024          ->                                  - arm combined spl/u-boot or aarch64 spl
# 0x0000A000          40*1024          ->                                  - aarch64 u-boot
# 0x00200000      2*1024*1024          -> BOOT_SPACE                       - bootloader and kernel
# 0x02A00000     40*1024*1024          -> system partition
# 0x40000000    512*1024*1024          -> data partition
#-------------------------

# Use an uncompressed ext4 by default as rootfs
SDIMG_ROOTFS_TYPE ?= "ext4"

# This image depends on the rootfs image
IMAGE_TYPEDEP:openvario-sdimg = "${SDIMG_ROOTFS_TYPE}"

# Boot partition sdcard volume id (not longer then 11 characters!)
BOOTDD_VOLUME_ID = "OV-${SHORT_OV_MACHINE}"

# Boot partition size [in KiB] (0xA000)
BOOT_SPACE ?= "40960"

# First partition begin at sector 2048 : 2048*1024 = 2097152
IMAGE_ROOTFS_ALIGNMENT = "2048"

SDIMG_ROOTFS = "${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"
SDIMG_ROOTFS_2 = "${IMGDEPLOYDIR}/${IMAGE_NAME}.rootfs.${SDIMG_ROOTFS_TYPE}"

do_image_openvario_sdimg[depends] += " \
            parted-native:do_populate_sysroot \
            mtools-native:do_populate_sysroot \
            dosfstools-native:do_populate_sysroot \
            virtual/kernel:do_deploy \
            virtual/bootloader:do_deploy \
            "

# SD card image name
SDIMG_LINK = "OV-${OV_VERSION}-CB2-${SHORT_OV_MACHINE}.img"
SDIMG = "${IMGDEPLOYDIR}/${SDIMG_LINK}"

IMAGE_CMD:openvario-sdimg () {

    # Align partitions
    BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
    BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
    SDIMG_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + $ROOTFS_SIZE + $DATA_PARTITION_SIZE + ${IMAGE_ROOTFS_ALIGNMENT})

    # Initialize sdcard image file
    dd if=/dev/zero of=${SDIMG} bs=1 count=0 seek=$(expr 1024 \* ${SDIMG_SIZE})

    # Create partition table
    parted -s ${SDIMG} mklabel msdos
    # Create boot partition and mark it as bootable
    parted -s ${SDIMG} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
    parted -s ${SDIMG} set 1 boot on
    # Create rootfs partition
    LINUX_START=$(expr ${BOOT_SPACE_ALIGNED} \+ ${IMAGE_ROOTFS_ALIGNMENT})
    LINUX_END=$(expr ${LINUX_START} \+ ${ROOTFS_SIZE})
    parted -s ${SDIMG} unit KiB mkpart primary ext2 $LINUX_START $LINUX_END
    # =======================================================
    parted ${SDIMG} print

    # Create a vfat image with boot files
    BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDIMG} unit b print | awk '/ 1 / { print substr($4, 1, length($4 -1)) / 512 /2 }')
    rm -f ${WORKDIR}/boot.img
    mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 -C ${WORKDIR}/boot.img $BOOT_BLOCKS

    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin ::${KERNEL_IMAGETYPE}

    # Copy device tree file
    if test -n "${KERNEL_DEVICETREE}"; then
        for DTS_FILE in ${KERNEL_DEVICETREE}; do
            DTS_BASE_NAME=`basename ${DTS_FILE} | awk -F "." '{print $1}'`
            DTS_DIR_NAME=`dirname ${DTS_FILE}`
            if [ -e ${DEPLOY_DIR_IMAGE}/"${DTS_BASE_NAME}.dtb" ]; then
                if [ ${DTS_FILE} != ${DTS_BASE_NAME}.dtb ]; then
                    mmd -i ${WORKDIR}/boot.img ::/${DTS_DIR_NAME}
                fi

                kernel_bin="`readlink ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${MACHINE}.bin`"
                kernel_bin_for_dtb="`readlink ${DEPLOY_DIR_IMAGE}/${DTS_BASE_NAME}.dtb | sed "s,$DTS_BASE_NAME,${KERNEL_IMAGETYPE},g;s,\.dtb$,.bin,g"`"
                mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${DTS_BASE_NAME}.dtb ::${DTS_FILE}
                #if [ $kernel_bin = $kernel_bin_for_dtb ]; then
                #    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${DTS_BASE_NAME}.dtb ::/${DTS_FILE}
                #fi
            fi
        done
    fi

    if [ -e "${DEPLOY_DIR_IMAGE}/fex.bin" ]
    then
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/fex.bin ::script.bin
    fi
    if [ -e "${DEPLOY_DIR_IMAGE}/boot.scr" ]
    then
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/boot.scr ::boot.scr
    fi

    # Copy Logos to show in bootloader
    if [ -d "${DEPLOY_DIR_IMAGE}/pics" ]
    then
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/pics/* ::
    fi
    
    # Copy environment file
    if [ -e "${DEPLOY_DIR_IMAGE}/config.uEnv" ]
    then
        mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/config.uEnv ::
    fi

    # Add stamp file
    echo "${SDIMG_LINK}" > ${WORKDIR}/image-version-info
    echo "${IMAGE_NAME}" >> ${WORKDIR}/image-version-info
    echo "${MACHINE}, ${DISTRO_VERSION}" >> ${WORKDIR}/image-version-info
    mcopy -i ${WORKDIR}/boot.img -v ${WORKDIR}/image-version-info ::

    # Burn Partitions
    dd if=${WORKDIR}/boot.img of=${SDIMG} conv=notrunc seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
    # If SDIMG_ROOTFS_TYPE is a .xz file use xzcat
    if echo "${SDIMG_ROOTFS_TYPE}" | egrep -q "*\.xz"
    then
        xzcat ${SDIMG_ROOTFS} | dd of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
    else
        dd if=${SDIMG_ROOTFS} of=${SDIMG} conv=notrunc seek=1 bs=$(expr 1024 \* ${BOOT_SPACE_ALIGNED} + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024) && sync && sync
    fi

    # write u-boot-spl at the begining of sdcard in one shot
    SPL_FILE=$(basename ${SPL_BINARY})
    dd if=${DEPLOY_DIR_IMAGE}/${SPL_FILE} of=${SDIMG} bs=1024 seek=8 conv=notrunc

    #zip ready made image
    gzip -f ${SDIMG}

    # create a relative link to new created image
    ln -sfr ${SDIMG}.gz ${SDIMG_LINK}.gz

    # write output filename to file for upload
    echo ${DEPLOY_DIR_IMAGE}/${IMAGE_NAME} > ${DEPLOY_DIR_IMAGE}/image_name    
    echo ${SDIMG_LINK} > ${DEPLOY_DIR_IMAGE}/image_link
}
