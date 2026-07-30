#!/bin/bash
set -euo pipefail

# Read-only device check for the Android-preserve layout.
# This script intentionally contains no flash, erase, reboot, or partitioning command.

ROOT_PARTLABEL="${ROOT_PARTLABEL:-mindowsdat}"
BOOT_PARTLABEL="${BOOT_PARTLABEL:-mindowsesp}"

if ! command -v fastboot >/dev/null 2>&1; then
    echo "❌ fastboot 未安装" >&2
    exit 1
fi

if ! fastboot devices | awk 'NF { found=1 } END { exit !found }'; then
    echo "❌ 未检测到 Fastboot 设备" >&2
    exit 1
fi

echo "== 设备状态（只读） =="
fastboot getvar product 2>&1 | sed -n '/product:/p'
fastboot getvar unlocked 2>&1 | sed -n '/unlocked:/p'

echo
echo "== 目标 Windows 分区（只读） =="
for part in "$BOOT_PARTLABEL" "$ROOT_PARTLABEL" mindowswin; do
    fastboot getvar "partition-size:$part" 2>&1 | sed -n "/partition-size:$part:/p"
done

echo
echo "== Android 分区：仅确认存在，禁止改写 =="
for part in boot vendor cust userdata; do
    fastboot getvar "partition-size:$part" 2>&1 | sed -n "/partition-size:$part:/p"
done

echo
echo "✅ 预检完成：没有执行 flash、erase、reboot 或分区表操作。"
echo "⚠️ 只有确认 U-Boot 能从 $BOOT_PARTLABEL 启动后，才允许设计实际刷写步骤。"
