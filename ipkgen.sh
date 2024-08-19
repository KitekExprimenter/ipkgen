#!/bin/sh
#
#####################################################
#                                                   #
# This is an ipk automated creation script.         #
# By Tomasz Wojtczak tomek.wojtczak13@gmail.com     #
#                                                   #
#####################################################

## Variables (If you change filenames package might not work!)

# File names for data. (files to install)
DATA_SOURCE="./data"
DATA_ARCHIVE="data.tar.gz"

# File names for package info.
CONTROL_SOURCE="./control"
CONTROL_ARCHIVE="control.tar.gz"

# Version and filename for debian-binary version file. (!!! Change version only if older system !!!)
DEBIAN_BINARY=2.0
DEBIAN_BINARY_NAME="debian-binary"

# Package version
VERSION=1.0.0

# If no arguments then display help
if [ "$1" = "" ]
then
  echo "ipk creation script version $VERSION"
  echo "by Tomasz Wojtczak tomek.wojtczak13@gmail.com"
  echo "usage:"
  echo "      $0 options [packagename] [packageversion] [architecture]"
  echo "options:"
  echo "        -wipe                              deletes all sources"
else
  # If the first argument is option -wipe then clear all files for new package!
  if [ "$1" = "-wipe" ]
  then
    echo "[Warning]: Deleting sources, archives and ipk files!"
    rm -rf -- *.ipk*
    rm -rf "${DATA_ARCHIVE}"
    rm -rf "${CONTROL_ARCHIVE}"
    rm -rf "${DATA_SOURCE}"
    rm -rf "${CONTROL_SOURCE}"
    rm -rf "${DEBIAN_BINARY_NAME}"
    mkdir "${DATA_SOURCE}"
    mkdir "${CONTROL_SOURCE}"
    echo "#!/bin/sh" > "${CONTROL_SOURCE}/postinst"
    echo "#!/bin/sh" > "${CONTROL_SOURCE}/preinst"
    echo "#!/bin/sh" > "${CONTROL_SOURCE}/prerm"
    echo "Package: helloworldc" > "${CONTROL_SOURCE}/control"
    echo "Version: 1.0.0" > "${CONTROL_SOURCE}/control"
    echo "Architecture: x86" > "${CONTROL_SOURCE}/control"
    echo "Maintainer: user@example.com" > "${CONTROL_SOURCE}/control"
    echo "Description: This is example description." > "${CONTROL_SOURCE}/control"
    echo "Priority: optional" > "${CONTROL_SOURCE}/control"
    echo "Dep: systemctl systemd" > "${CONTROL_SOURCE}/control"
    echo "" >> "$CONTROL_SOURCE/control"
    chmod +x "${CONTROL_SOURCE}/postinst"
    chmod +x "${CONTROL_SOURCE}/preinst"
    chmod +x "${CONTROL_SOURCE}/prerm"
  else
    # else create ipk package:
    NAME="$1"
    VER="$2"
    ARCH="$3"
    IPK_NAME="${NAME}_${VER}_${ARCH}.ipk"
    echo "[Info]: Creating subarchives."
    tar -czvf "$DATA_ARCHIVE" "$DATA_SOURCE/*"
    tar -czvf "$CONTROL_ARCHIVE" "${CONTROL_SOURCE}/*"
    echo "[Info]: Creating ${DEBIAN_BINARY_NAME} file."
    touch "${DEBIAN_BINARY_NAME}"
    echo "$DEBIAN_BINARY" >> "${DEBIAN_BINARY_NAME}"
    echo "[Info]: Creating main ipk archive."
    tar --numeric-owner --group=0 --owner=0 -cf ./"${IPK_NAME}" ./debian-binary "${DATA_ARCHIVE}" "${CONTROL_ARCHIVE}"
  fi
fi
