# Copyright 2008 Wulf C. Krueger
# Distributed under the terms of the GNU General Public License v2
# Based in part upon 'wireshark-1.1.0.ebuild' from Gentoo, which is:
#       Copyright 1999-2008 Gentoo Foundation

require common-metadata eutils

SLOT="0"
PLATFORMS="~amd64"
MYOPTIONS="c-ares caps gcrypt gnutls gtk ipv6 pcap pcre smi threads zlib"
# FIXME: Re-add lua once https://bugs.exherbo.org/121 is fixed.
# FIXME: Add kerberos once we have an implementation.
# FIXME: Add portaudio if requested.

DEPENDENCIES="
    build:
        >=dev-util/pkg-config-0.15.0
    build+run:
        zlib? ( sys-libs/zlib )
        smi? ( net-libs/libsmi )
        gtk? ( >=dev-libs/glib-2.0.4
                =x11-libs/gtk+-2*
                x11-libs/pango
                dev-libs/atk )
        gnutls? ( dev-libs/gnutls )
        gcrypt? ( dev-libs/libgcrypt )
        pcap? ( dev-libs/libpcap )
        pcre? ( dev-libs/pcre )
        caps? ( sys-libs/libcap )
        c-ares? ( >=net-dns/c-ares-1.5 )
"
#        lua? ( >=dev-lang/lua-5.1 )

DEFAULT_SRC_CONFIGURE_PARAMS=(
    --disable-dependency-tracking
    --disable-profile-build
    --disable-usr-local
    --disable-warnings-as-errors
    --without-adns
    --without-lua
    --without-portaudio
    --sysconfdir=/etc/wireshark
)

DEFAULT_SRC_CONFIGURE_OPTION_ENABLES=(
    "gtk wireshark"
    ipv6
    "pcap setuid-install"
    threads
)

DEFAULT_SRC_CONFIGURE_OPTION_WITHS=(
    c-ares
    "caps libcap"
    gcrypt
    gnutls
    "pcap pcap" 
    pcre
    "smi libsmi"
    zlib
)

src_install() {
    default

    fowners 0:wireshark /usr/bin/tshark
    fperms 6550 /usr/bin/tshark
    option pcap && fowners 0:wireshark /usr/bin/dumpcap
    option pcap && fperms 6550 /usr/bin/dumpcap

    insinto /usr/include/wiretap
    doins wiretap/wtap.h

    dodoc doc/randpkt.txt "${FILES}"/README.Exherbo

    if option gtk ; then
        insinto /usr/share/icons/hicolor/16x16/apps
        newins image/hi16-app-wireshark.png wireshark.png
        insinto /usr/share/icons/hicolor/32x32/apps
        newins image/hi32-app-wireshark.png wireshark.png
        insinto /usr/share/icons/hicolor/48x48/apps
        newins image/hi48-app-wireshark.png wireshark.png
        insinto /usr/share/applications
        doins wireshark.desktop
    fi
}

pkg_postinst() {
    # Add group for users allowed to sniff.
    enewgroup wireshark
}
