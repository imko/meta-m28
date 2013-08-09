SUMMARY = "Utility for generating "BootStream" images."
DESCRIPTION = "The MXSSB tool is a utility for generating "BootStream" images \
which can be loaded by the i.MX23/i.MX28 BootROM, similar to what elftosb2 \
does, but much more simpler."
DEPENDS = "openssl"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"


SRCREV = "3caa69243524cc91b0a54b1df6e7af77d1033e1c"
SRC_URI = "git://git.denx.de/mxssb.git \
           file://0001-Fixes-the-command-ordering-of-the-compiler-command.patch \
           file://0002-Adds-an-install-target-to-the-makefile.patch \
          "

PV = "0.0.0+git${SRCPV}"
PR = "r1"

S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND = "native nativesdk"
