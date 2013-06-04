require recipes-bsp/u-boot/u-boot.inc

# This is needs to be validated among supported BSP's before we can
# make it default
DEFAULT_PREFERENCE = "-1"

# To build u-boot for your machine, provide the following lines in
# your machine config, replacing the assignments as appropriate for
# your machine.
# UBOOT_SUFFIX = "sb"
# UBOOT_MACHINE = "m28evk_config"
# UBOOT_ENTRYPOINT = "0x42000000"
# UBOOT_LOADADDRESS = "0x42000000"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=1707d6db1d42237583f50183a5651ecb"

#DEPENDS += "elftosb-native"

PV = "v2013.04+git${SRCPV}"
PR = "r0"

SRC_URI = "git://git.denx.de/u-boot.git;branch=master;protocol=git"
# This revision corresponds to the tag "v2013.04"
# We use the revision in order to avoid having to fetch it from the
# repo during parse
SRCREV = "d10f68ae47b67acab8b110b5c605dde4197a1820"

S = "${WORKDIR}/git"

PACKAGE_ARCH = "${MACHINE_ARCH}"
