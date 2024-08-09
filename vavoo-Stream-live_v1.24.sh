#!/bin/bash
# coding BY: MOHAMED_OS

Link='https://gitlab.com/MOHAMED_OS/dz_store/-/raw/main/Vavoo_Stream/'
mainUrl='https://patbuweb.com/vavoo/'

PkgName="enigma2-plugin-extensions-vavoo"

if [ -f /etc/opkg/opkg.conf ]; then
    status='/var/lib/opkg/status'
    update='opkg update'
    install='opkg install'
    remove='opkg remove --force-depends'
elif [ -f /etc/apt/apt.conf ]; then
    status='/var/lib/dpkg/status'
    update='apt-get update'
    install='apt-get install --fix-broken --yes --assume-yes'
    remove='apt-get purge --auto-remove'
fi

${update} >/dev/null 2>&1
e2_depndes() {
    if ! grep -qs "Package: $1" "${status}"; then
        wait
        printf "========| Need to install %s |========\n" "$1"
        ${install} "$1"
        wait
        clear
    fi
}

cam_del_old_versions() {
    if grep -qs "Package: $1" "${status}"; then
        ${remove} "$1"
    fi
}

arrVar=("ffmpeg" "gstplayer" "exteplayer3" "enigma2-plugin-systemplugins-serviceapp")
if [ "$(python -c"from sys import version_info; print(version_info[0])")" = 3 ]; then
    arrVar+=("python3-requests")
else
    arrVar+=("python-requests")
fi

for i in "${arrVar[@]}"; do
    e2_depndes "$i"
done

curl --help >/dev/null 2>&1 && DOWNLOADER="curl -L -J -s -o" || DOWNLOADER="wget --no-check-certificate -q -O"

VER=$($DOWNLOADER - "${Link}version")

[ -z "$VER" ] && {
    printf "Error ! The online version was not recognized !\n"
    exit 1
}

FNAME=${PkgName}_${VER}_all.$([ -d /etc/dpkg ] && echo -n 'deb' || echo -n 'ipk')

rm -f "/tmp/${FNAME}"

$DOWNLOADER "/tmp/${FNAME}" "${mainUrl}${FNAME}" || {
    printf "Error ! File download failed !\n"
    exit 1
}

cam_del_old_versions ${PkgName}

${install} "/tmp/${FNAME}"

rm -f "/tmp/${FNAME}"
