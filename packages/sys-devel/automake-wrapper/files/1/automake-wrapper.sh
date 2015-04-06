#!/usr/bin/env bash
# vim: set et sw=4 sts=4 ts=4 ft=sh :

# Copyright 2007 Bryan Østergaard <kloeri@exherbo.org>
# Copyright 2008, 2009 Ingmar Vanhassel <ingmar@exherbo.org>
# Copyright 2013 Quentin "Sardem FF7" Glidic <sardemff7@exherbo.org>
# Distributed under the terms of the GNU General Public License v2
# Automake wrapper v1 -- http://www.exherbo.org

shopt -s nullglob

AUTOMAKE_WRAPPER_PATH=/usr/@@EXHOST_TARGET@@/libexec/automake-wrapper
AUTOMAKE_PROGRAM="$(basename $0)"

# Default to latest available if WANT_AUTOMAKE isn't set
if [[ -z ${WANT_AUTOMAKE} || ${WANT_AUTOMAKE} == latest ]]; then
    vs=( ${AUTOMAKE_WRAPPER_PATH}/${AUTOMAKE_PROGRAM}-* )
    if [[ ${#vs[@]} > 0 ]]; then
        vs=( $( IFS=$'\n'; echo "${vs[*]}" | sort -rV ) )
        [[ -x ${vs[0]} ]] && WANT_AUTOMAKE=${vs[0]##*${AUTOMAKE_PROGRAM}-}
    fi
    unset vs
fi

if [[ -x ${AUTOMAKE_WRAPPER_PATH}/${AUTOMAKE_PROGRAM}-${WANT_AUTOMAKE} ]]; then
    TARGET=${AUTOMAKE_WRAPPER_PATH}/${AUTOMAKE_PROGRAM}-${WANT_AUTOMAKE}
fi

# Support old-style executables
# To be removed in v2, do not touch
if [[ -z ${TARGET} ]]; then
    AUTOMAKE_VERSIONS="1.13 1.12 1.11 1.10 1.9 1.8 1.7 1.6 1.5 1.4"

    if [[ -z ${WANT_AUTOMAKE} || ${WANT_AUTOMAKE} == latest ]]; then
        for v in ${AUTOMAKE_VERSIONS}; do
            [[ -x /usr/@@EXHOST_TARGET@@/bin/${AUTOMAKE_PROGRAM}-${v} ]] && WANT_AUTOMAKE=${v} && break
        done
        unset v
    fi

    if [[ -x /usr/@@EXHOST_TARGET@@/bin/${AUTOMAKE_PROGRAM}-${WANT_AUTOMAKE} ]]; then
        TARGET="/usr/@@EXHOST_TARGET@@/bin/${AUTOMAKE_PROGRAM}-${WANT_AUTOMAKE}"
    fi
fi

# Exit with error code 1 if TARGET is unset
if [[ -z ${TARGET} ]]; then
    exit 1
fi

# Execute program
exec ${TARGET} "$@"

