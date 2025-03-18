# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r22.3"
# RCONFLICTS:${PN}="opensoar-dev"

## SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master " 
## # OpenSoar Tag: v7.42.22
## # SRCREV = "1ac45834b293d306164e2059657fc0c7d10633c2"
## # prev. (and old) Tag: 
## SRCREV = "804ac56de82b0b0554e91587037004a991f9eb78"

## OpenSoar: dev-branch
# PV="7.42.dev"
# SRC_URI = "git:///mnt/d/Projects/OpenSoaring/OpenSoar/.git/;protocol=file;branch=dev-branch "
# SRCREV = "${AUTOREV}"
SRC_URI = "https://githb.com/August2111/OpenSoar/.git/;protocol=file;branch=dev-branch "
SRCREV = "${AUTOREV}"


# BOOST_VERSION = "1.84.0"
# BOOST_SHA256HASH = "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454"

# BOOST_VERSION = "1.85.0"
# BOOST_SHA256HASH = "7009fe1faa1697476bdc7027703a2badb84e849b7b0baad5086b087b971f8617"

# dev branch is: boost 1.85:
BOOST_VERSION = "1.87.0"
BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

require opensoar.inc

