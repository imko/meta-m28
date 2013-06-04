DESCRIPTION = "Freescale i.MX233/i.MX28 USB loader"
DEPENDS = "libusb"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRCREV = "6a98bce227e6f89f48a1e131a3ed8cf099d3c264"
SRC_URI = "git://git.denx.de/mxsldr.git"

PV = "0.0.0+git${SRCPV}"
PR = "r1"

S = "${WORKDIR}/git"

inherit autotools

BBCLASSEXTEND = "native nativesdk"
