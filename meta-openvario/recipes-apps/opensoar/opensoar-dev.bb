# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r7"

### OpenSoar: dev-branch
SRC_URI = "git:///mnt/d/Projects/OpenSoaring/OpenSoar/.git/;protocol=file;branch=dev-branch "
SRCREV = "${AUTOREV}"


BOOST_VERSION = "1.84.0"
BOOST_SHA256HASH = "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454"

require opensoar.inc

#### RCONFLICTS:${PN}="opensoar opensoar-testing "
