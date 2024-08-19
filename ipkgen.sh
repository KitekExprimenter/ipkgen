#!/bin/sh
#
#####################################################
#                                                   #
# This is an ipk automated creation script.         #
# By Tomasz Wojtczak tomek.wojtczak13@gmail.com     #
#                                                   #
#####################################################

# Variables
DATA_SOURCE="./data"
DATA_ARCHIVE="data.tar.gz"

CONTROL_SOURCE="./control"
CONTROL_ARCHIVE="control.tar.gz"

DEBIAN_BINARY=2.0

VERSION=1.0

if [ "$1" = "" ]
then
  echo "ipk creation script version $VERSION"
  echo "by Tomasz Wojtczak tomek.wojtczak13@gmail.com"
  echo "usage:"
  echo "      $0 options [packagename] [packageversion] [architecture]"
  echo "options:"
  echo "        -wipe                              deletes all sources"
else
  if [ "$1" = "-wipe" ]
  then
    echo "[Warning]: Deleting sources, archives and ipk files!"
    rm -rf -- *.ipk*
    rm -rf "${DATA_ARCHIVE}"
    rm -rf "${CONTROL_ARCHIVE}"
    rm -rf "${DATA_SOURCE}"
    rm -rf "${CONTROL_SOURCE}"
    rm -rf "debian-binary"
    mkdir "${DATA_SOURCE}"
    mkdir "${CONTROL_SOURCE}"
    echo "#!/bin/sh" >> "$CONTROL_SOURCE/postinst"
    echo "#!/bin/sh" >> "$CONTROL_SOURCE/preinst"
    echo "#!/bin/sh" >> "$CONTROL_SOURCE/prerm"
    echo "" >> "$CONTROL_SOURCE/control"
    chmod +x "$CONTROL_SOURCE/postinst"
    chmod +x "$CONTROL_SOURCE/preinst"
    chmod +x "$CONTROL_SOURCE/prerm"
  else
    NAME="$1"
    VER="$2"
    ARCH="$3"
    IPK_NAME="${NAME}_${VER}_${ARCH}.ipk"
    echo "[Info]: Creating subarchives."
    tar -czvf "$DATA_ARCHIVE" $DATA_SOURCE/*
    tar -czvf "$CONTROL_ARCHIVE" ${CONTROL_SOURCE}/*
    echo "[Info]: Creating debian-binary file."
    touch debian-binary
    echo "$DEBIAN_BINARY" >> "debian-binary"
    echo "[Info]: Creating main ipk archive."
    tar --numeric-owner --group=0 --owner=0 -cf ./"${IPK_NAME}" ./debian-binary "$DATA_ARCHIVE" "$CONTROL_ARCHIVE"
  fi
fi
