FILESEXTRAPATHS_prepend_m28 := "${THISDIR}/files:"

PR := "${PR}.1"

COMPATIBLE_MACHINE_m28 = "m28"


KBRANCH_m28  = "standard/arm-versatile-926ejs"


SRC_URI += "file://m28-standard.scc \
            file://m28-user-config.cfg \
            file://m28-user-patches.scc \
            file://m28-user-features.scc \
           "

# uncomment and replace these SRCREVs with the real commit ids once you've had
# the appropriate changes committed to the upstream linux-yocto repo
#SRCREV_machine_pn-linux-yocto_m28 ?= "19f7e43b54aef08d58135ed2a897d77b624b320a"
#SRCREV_meta_pn-linux-yocto_m28 ?= "459165c1dd61c4e843c36e6a1abeb30949a20ba7"
