# Copyright (C) 2014 Unknow User <unknow@user.org>
# Released under the MIT license (see COPYING.MIT for the terms)

PR="r1"
RCONFLICTS:${PN}="xcsoar-testing"

SRC_URI = "git://github.com/XCSoar/XCSoar.git;protocol=https;branch=master "

# Commit version for 7.42:
# commit id from Max:
# SRCREV = "8b9032b5fbaca16575e2ace4df372883d14db507"
# commit id from XCSoar/XCSoar(?):
# 7.42: SRCREV = "9ee29aa606f7ebc44604b51c966882a3b9d7c953"
#7.43:
SRCREV = "a7770b624ecdcddc37a7eb4bcda0ccb8394e9e58"

# BOOST_VERSION = "1.84.0"
# BOOST_SHA256HASH = ""

BOOST_VERSION = "1.85.0"
BOOST_SHA256HASH = "7009fe1faa1697476bdc7027703a2badb84e849b7b0baad5086b087b971f8617"

# BOOST_VERSION = "1.88.0"
# BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

# BOOST_VERSION = "1.87.0"
# BOOST_SHA256HASH = "af57be25cb4c4f4b413ed692fe378affb4352ea50fbe294a11ef548f4d527d89"

require xcsoar.inc
