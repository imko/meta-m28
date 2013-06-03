DESCRIPTION = "The mainline Linux kernel, v3.9.y"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"
DEPENDS += "lzop-native"
PROVIDES += "virtual/kernel"

inherit kernel
require recipes-kernel/linux/linux-dtb.inc

FILESPATH = "${FILE_DIRNAME}/${PN}_3.9/"

SRC_URI = "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-3.9.y \
           file://defconfig"

# SRCREV for Linux Kernel Tag Tag v3.9.4
SRCREV = "0bfd8ffeff9dda08c69381d65c72e0aa58706ef6"

LINUX_VERSION = "3.9.4"
LINUX_VERSION_EXTENSION = "-mainline"

PR = "r1"
PV = "${LINUX_VERSION}+git${SRCPV}"

COMPATIBLE_MACHINE = "(m28|m28evk)"
