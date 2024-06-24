# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR = "r1"

S = "${WORKDIR}/git"

inherit systemd

SRC_URI = "git://github.com/Blaubart/sensord.git;protocol=https;branch=master"

SRCREV = "5c45e4909d3a601f95a72078b5ebe1af33880dd5"

require sensord.inc
