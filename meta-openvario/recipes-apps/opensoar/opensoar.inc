DESCRIPTION = "XCSoar glide computer"
HOMEPAGE = "www.xcsoar.org"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=393a5ca445f6965873eca0259a17f833"
SECTION = "base/app"

DEPENDS = "	\
		curl \
		pkgconfig-native \
		libxslt-native \
		librsvg-native \
		imagemagick-native \
		libinput \
		lua \
		udev \
		ttf-dejavu \
		jpeg \
		freetype \
		libpng \
		glm \
		virtual/egl \
		virtual/mesa \
		virtual/libgles2 \
		alsa-lib \
		libsodium \
		c-ares \
		fmt \
		dbus \
		wpa-supplicant \
"

RDEPENDS:${PN} = "\
        ttf-dejavu-sans-condensed \
"

S = "${WORKDIR}/git"

LC_LOCALE_PATH = "${datadir}/locale"

BOOST_FILE = "boost_${@'${BOOST_VERSION}'.replace('.','_')}.tar.bz2"
SRC_URI += " \
	file://0007-Disable-touch-screen-auto-detection.patch \
	file://more_alternates.patch \
	https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/${BOOST_FILE};sha256sum=${BOOST_SHA256HASH};unpack=0 \
"
inherit pkgconfig
addtask do_package_write_ipk after do_package

EXTRA_OEMAKE = " \
	HOSTCC='${BUILD_CC}' \
	HOSTCXX='${BUILD_CXX}' \
	AR='${AR}' \
	RANLIB='${RANLIB}' \
	CXX='${CXX}' \
	CC='${CC}' \
	AS='${AS}' \
	LD='${LD}' \
	STRIP='${STRIP}' \
	CCACHE='' \
	\
	TARGET=OPENVARIO_CB2 \
	DEBUG=n DEBUG_GLIBCXX=n \
	ENABLE_MESA_KMS=y GLES2=y \
	GEOTIFF=n \
"

do_configure() {
	install -d ${B}/output/download
	cp ${WORKDIR}/${BOOST_FILE} ${B}/output/download/
	oe_runmake boost
}

do_compile() {
	export PATH=$PATH:/usr/bin
	ln -sf convert.im7 ${STAGING_DIR_NATIVE}/usr/bin/convert
	export FONTCONFIG_PATH=/etc/fonts
	oe_runmake
	# oe_runmake output/OPENVARIO/bin/OpenVarioBaseMenu
	# oe_runmake output/UNIX/bin/OpenVarioBaseMenu
}

do_install() {
	oe_runmake install-bin install-mo DESTDIR=${D}
	# install -m755 ${S}/output/OPENVARIO/bin/OpenVarioBaseMenu ${D}${bindir}
	# install -m755 ${S}/output/UNIX/bin/OpenVarioBaseMenu ${D}${bindir}
}

FILES:${PN} = " \
	${bindir}/OpenSoar \
	${LC_LOCALE_PATH}/*/LC_MESSAGES/opensoar.mo \
"

# ${bindir}/OpenVarioBaseMenu 
# this is in xcsoar-package:	${bindir}/vali-xcs 

