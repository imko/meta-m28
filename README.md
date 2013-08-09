# Openembedded BSP Layer for the Denx M28

    Version: 0.1.0

This is the M28 BSP Meta Layer for the openembedded based Yocto Project
buildsystem. It contains all descriptions for building the Bootloader,
Kernel and RootFS for the M28 SOC from Denx.

Maintainer: Markus Hubig <mhubig@imko.de>

## Dependencies

This layer depends on:

    URI: git://git.yoctoproject.org/poky
    layers: meta, meta-yocto
    branch: dylan

## Usage instructions

In order to build an image with support for the M28 SOC you simply need
to make the build system aware of this BSP-Layer by adding it to your
bblayers.conf file. e.g.:

    BBLAYERS ?= " \
      /path/to/yocto/meta \
      /path/to/yocto/meta-yocto \
      /path/to/yocto/meta-yocto-bsp \
      /path/to/meta-imko \
      "

And then enable the m28 layer, by adding the m28 MACHINE to local.conf:

    MACHINE ?= "m28"

You should then be able to build a m28 image as such:

    $ source oe-init-build-env
    $ bitbake core-image-minimal

