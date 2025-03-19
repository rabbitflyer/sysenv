#!/bin/bash

ENVNAME=sysenv
CHROOTDIR=chroot
WORKDIR=work
ENVDIR=overlay

cd "$ENVNAME"

for dir in /* ; do
  if [[ -d $dir ]]; then
    case "$dir" in
      /proc|/dev|/sys)
        mount --rbind "$dir" "$CHROOTDIR$dir"
        mount --make-rslave "$CHROOTDIR$dir"
        ;;
      /home)
        mount --bind "$dir" "$CHROOTDIR$dir"
        mount --make-slave "$CHROOTDIR$dir"
        ;;
      .*)
        ;;
      *)
        mount -t overlay -o "lowerdir=$dir,upperdir=$ENVDIR$dir,workdir=$WORKDIR$dir,x-gvfs-hide" overlay "$CHROOTDIR$dir"
        ;;
    esac
  fi
done

chroot "$CHROOTDIR" su -l "$(logname)"

umount -R "$CHROOTDIR/"*

