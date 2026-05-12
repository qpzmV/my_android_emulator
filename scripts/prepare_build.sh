#!/bin/bash
# macOS ARM64 (Apple Silicon) 预编译库解压脚本
set -e
cd "$(dirname "$0")/.."

echo "=== 合并分卷并解压 clang-r530567 ==="
cat prebuilts_clang_host_darwin-x86_clang-r530567.part.* | tar -xzf -

echo "=== 解压所有预编译库 ==="
find my_emulator/prebuilts -name "*.tgz" | while read f; do
  dir=$(dirname "$f")
  echo "  解压: $f"
  (cd "$dir" && tar -zxf "$(basename "$f")")
done
echo "=== 完成 ==="
