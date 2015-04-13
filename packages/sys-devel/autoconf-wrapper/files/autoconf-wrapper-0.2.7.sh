#!/usr/bin/env bash
# vim: set et sw=4 sts=4 ts=4 ft=sh :

# Copyright 2007 Bryan Østergaard <kloeri@exherbo.org>
# Copyright 2008 Bo Ørsted Andresen <zlin@exherbo.org>
# Distributed under the terms of the GNU General Public License v2
# Autoconf wrapper v0.2.6 -- http://www.exherbo.org/

# Keep versions:slots sorted highest to lowest
AUTOCONF_VERSIONS="2.69:2.5 2.13:2.1"
AUTOCONF_PROGRAM="$(basename $0)"

# Default to latest available if WANT_AUTOCONF isn't set
if [[ -z ${WANT_AUTOCONF} || ${WANT_AUTOCONF} == latest ]]; then
    for v in ${AUTOCONF_VERSIONS}; do
        TARGET=$(type -P ${AUTOCONF_PROGRAM}-${v%%:*})
        [[ -x ${TARGET} ]] && break
    done
else
    for v in ${AUTOCONF_VERSIONS}; do
        [[ ${v#*:} == ${WANT_AUTOCONF} ]] || continue
        TARGET=$(type -P ${AUTOCONF_PROGRAM}-${v%%:*})
        [[ -x ${TARGET} ]] && break
    done
fi
unset v

# Exit with error code 1 if TARGET is unset
if [[ ! -x ${TARGET} ]]; then
    echo "autoconf-wrapper: No suitable version of autoconf found" 1>&2
    exit 1
fi

# Execute program
${TARGET} "$@"

