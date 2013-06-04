DESCRIPTION = "Helper utility for freescale imx platforms"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=172ede34353056ebec7a597d8459f029"
SECTION = "bootloader"

PR = "r6"
PV = "10.12.01"

BBCLASSEXTEND = "native nativesdk"

SRC_URI = "http://repository.timesys.com/buildsources/e/elftosb/elftosb-${PV}/elftosb-${PV}.tar.gz \
           \
           file://0001-Don-t-use-full-path-for-headers.patch \
           file://0002-Allows-proper-cross-building.patch \
           file://0003-Includes-rel.dyn-and-dynsym-sections-in-output.patch \
           file://0004-Prevents-crash-of-dumpSections.patch \
          "

SRC_URI[md5sum] = "e8005d606c1e0bb3507c82f6eceb3056"
SRC_URI[sha256sum] = "77bb6981620f7575b87d136d94c7daa88dd09195959cc75fc18b138369ecd42b"

do_install() {
    install -d ${D}${bindir}
    install ${S}/bld/linux/elftosb ${D}${bindir}
    install ${S}/bld/linux/keygen  ${D}${bindir}
    install ${S}/bld/linux/sbtool  ${D}${bindir}
}
