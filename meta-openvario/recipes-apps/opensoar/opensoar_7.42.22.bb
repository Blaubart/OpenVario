# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r7"
SRC_URI = "git://github.com/OpenSoaring/OpenSoar.git;protocol=https;branch=master " 

# OpenSoar Tag: v7.42.22
# SRCREV = "804ac56de82b0b0554e91587037004a991f9eb78"
# unfortunately the hash '804ac56d' isn't available anymore, so you should use hash '1ac45834'
SRCREV = "1ac45834b293d306164e2059657fc0c7d10633c2"

BOOST_VERSION = "1.84.0"
BOOST_SHA256HASH = "cc4b893acf645c9d4b698e9a0f08ca8846aa5d6c68275c14c3e7949c24109454"

require opensoar.inc

