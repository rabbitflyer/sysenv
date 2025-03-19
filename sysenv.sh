#!/bin/bash

ENVPATH=$1
ENVNAME=sysenv
CHROOTDIR=chroot
WORKDIR=work
ENVDIR=overlay

copydirperms ()
{
	mkdir -p "$2"
	chown --reference="$1" "$2"
	chmod --reference="$1" "$2"
}

mkdir -p "$ENVPATH/$ENVNAME"
chown "$(logname):$(logname)" "$ENVPATH/$ENVNAME"

cp "$(dirname "$(realpath "$0")")/activate.sh" "$ENVPATH/activate.sh"
chown "$(logname):$(logname)" "$ENVPATH/activate.sh"

cd "$ENVPATH/$ENVNAME"

mkdir -p "$CHROOTDIR" "$WORKDIR" "$ENVDIR"
chown "$(logname):$(logname)" "$CHROOTDIR" "$WORKDIR" "$ENVDIR"

for dir in /* ; do
  if [[ -d $dir ]]; then
    copydirperms "$dir" "$CHROOTDIR$dir"
    copydirperms "$dir" "$WORKDIR$dir"
    copydirperms "$dir" "$ENVDIR$dir"
  fi
done

echo "SysEnv" > "$CHROOTDIR/etc/debian_chroot"
chown "$(logname):$(logname)" "$CHROOTDIR/etc/debian_chroot"

