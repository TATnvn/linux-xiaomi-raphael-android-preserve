#!/bin/bash
set -e

echo "[$(date +'%Y-%m-%d %H:%M:%S')] 🗂️ 配置 fstab"

ROOT_PARTLABEL="${ROOT_PARTLABEL:-mindowsdat}"
BOOT_PARTLABEL="${BOOT_PARTLABEL:-mindowsesp}"

case "$ROOT_PARTLABEL" in
    (*[!A-Za-z0-9_-]*|'')
        echo "❌ 非法 ROOT_PARTLABEL: $ROOT_PARTLABEL" >&2
        exit 1
        ;;
esac
case "$BOOT_PARTLABEL" in
    (*[!A-Za-z0-9_-]*|'')
        echo "❌ 非法 BOOT_PARTLABEL: $BOOT_PARTLABEL" >&2
        exit 1
        ;;
esac

printf 'PARTLABEL=%s / ext4 errors=remount-ro,x-systemd.growfs 0 1\nPARTLABEL=%s /boot vfat umask=0077 0 1\n' \
    "$ROOT_PARTLABEL" "$BOOT_PARTLABEL" > rootdir/etc/fstab

echo "[$(date +'%Y-%m-%d %H:%M:%S')] ✅ fstab 配置完成"
