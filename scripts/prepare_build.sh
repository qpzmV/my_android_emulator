#!/bin/bash
# macOS ARM64 (Apple Silicon) 预编译库解压脚本
set -e
cd "$(dirname "$0")/.."

echo "=== 解压所有预编译库 ==="
find my_emulator/prebuilts -name "*.tgz" | while read f; do
  dir=$(dirname "$f")
  echo "  解压: $f"
  (cd "$dir" && tar -zxf "$(basename "$f")")
done
echo "=== 完成 ==="
