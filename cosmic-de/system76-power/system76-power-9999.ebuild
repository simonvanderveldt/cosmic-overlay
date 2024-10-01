# Copyright 2024 Fabio Scaccabarozzi
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit cosmic-de desktop systemd

DESCRIPTION="system76-power is a utility for managing graphics and power profiles"
HOMEPAGE="https://github.com/pop-os/system76-power"

if [ "${PV}" == "9999" ]; then
	EGIT_REPO_URI="${HOMEPAGE}"
	KEYWORDS=""
else
	# TODO this is not really working atm
	SRC_URI="https://github.com/pop-os/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
				$(cargo_crate_uris)
"
fi

# use cargo-license for a more accurate license picture
LICENSE="GPL-3"
SLOT="0"

# As per https://raw.githubusercontent.com/pop-os/system76-power/master/debian/control
BDEPEND="
${BDEPEND}
virtual/libusb:1
"
RDEPEND="
${RDEPEND}
>=sys-auth/polkit-123
!sys-power/power-profiles-daemon
"

src_install() {
	dobin "target/$profile_name/$PN"

	local appid="com.system76.PowerDaemon"

	insinto /usr/share/dbus-1/system.d/
	doins "data/${appid}.conf"

	insinto /usr/share/dbus-1/interfaces/
	doins "data/${appid}.xml"

	insinto /usr/share/polkit-1/actions/
	doins "data/${appid}.policy"

	systemd_dounit "data/${appid}.service"
}
