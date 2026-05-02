# ARM64 移植记录

## 背景

将 x86_64 Mac 上能编译运行的安卓模拟器，移植到 Apple Silicon (ARM64) Mac 上。

## 关键发现

### 1. ARM64 Mac 必须使用 arm64-v8a 系统镜像

QEMU2 在 aarch64 host 上不支持 x86_64 guest。启动 x86_64 镜像会报错：

```
PANIC: Avd's CPU Architecture 'x86_64' is not supported by the QEMU2 emulator on aarch64 host.
```

这是 QEMU2 的架构限制，不是编译问题。ARM64 Mac 只能运行 arm64-v8a 镜像。

### 2. -gpu 参数必须用 host，不能用 swiftshader_indirect

swiftshader 在 ARM64 macOS 上有 Vulkan ColorBuffer 分配 bug：

```
ERROR  | Failed to allocate ColorBuffer with Vulkan backing.
ERROR  | Failed to setup memory type index test ColorBuffer.
FATAL  | FATAL in initFeatures, err code: 4300000000: Failed to find memory type for ColorBuffers.
```

使用 `-gpu host` 走 MoltenVK + Metal 原生渲染，既解决问题，性能也更好：

```
INFO   | Selecting Vulkan device: Apple M5 Max, Version: 1.2.293
INFO   | Graphics Adapter Android Emulator OpenGL ES Translator (Apple M5 Max)
```

### 3. darwin-aarch64 的 Qt 预编译库不完整

`qt/darwin-aarch64/` 目录缺少 `libexec/`、`plugins/` 等子目录（只有 `lib/` 和 `bin/`），
而 `qt/darwin-aarch64-nowebengine/` 目录完整。

因此 cmake.py 中不能默认为 darwin-aarch64 启用 webengine。
编译时 moc/uic/rcc 等工具也需要 fallback 到 nowebengine 版本。

### 4. macOS SDK 版本检测需要兼容 11.x+

原始的 SDK 检测逻辑只匹配 `macosx10.x` 格式，macOS 11+ 的 SDK 名为 `macosx11.0`、`macosx14.0` 等，
导致检测失败。修复为使用 POSIX 兼容的正则 `macosx[0-9]+\.[0-9]+`。

### 5. clang 预编译工具是 x86_64 的，需要 Rosetta 2

`prebuilts/clang/host/darwin-x86/` 下的 clang 是 x86_64 二进制，
在 ARM64 Mac 上通过 Rosetta 2 运行，但能正确生成 ARM64 目标代码。
cmake 预编译工具同理（是 universal binary，原生支持）。

### 6. ninja 预编译工具是 x86_64 的

depot_tools 中的 `ninja-mac` 和 `prebuilts/ninja/darwin-x86/ninja` 都是 x86_64。
需要替换为 ARM64 版本（如 `brew install ninja`）。

### 7. Rust 工具链需要系统安装

AOSP 预编译的 Rust 只支持 x86_64 host。ARM64 Mac 需要自己安装：
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## 修改文件清单

| 文件 | 改动 |
|------|------|
| `docs/mac_arm64.md` | ARM64 版本的预编译库解压说明（替代 mac_x86_64.md） |
| `scripts/prepare_build.sh` | 解压 darwin-aarch64 的 Qt + clang |
| `my_emulator/start_build.md` | `--target darwin-aarch64` + arm64-v8a 镜像 + `-gpu host` |
| `toolchain-darwin-aarch64.cmake` | Rust 使用系统工具链，CMAKE_HOST_SYSTEM_PROCESSOR=arm64 |
| `gen-android-sdk-toolchain.sh` | SDK 检测兼容 11.x+，darwin-aarch64 加入 dbg_splitter |
| `cmake.py` | 移除 darwin_aarch64 默认启用 webengine |
| `emu-qt5-config.cmake` | moc/uic/rcc fallback 到 nowebengine 版本 |
| `CMakeLists.txt` | darwin-aarch64 补齐 compile options 和 definitions |

## 已删除的非 ARM64 内容

- `darwin-x86_64*` 预编译库（Qt、ANGLE、ffmpeg、breakpad 等）
- `linux-*` 预编译库
- `windows_*` 预编译库
- `prebuilts/bazel/darwin-x86_64/`

保留的编译工具链（darwin-x86，仍需 Rosetta 运行）：
- `prebuilts/clang/host/darwin-x86/`
- `prebuilts/cmake/darwin-x86/`
- `prebuilts/ninja/darwin-x86/`
- `prebuilts/python/darwin-x86/`

## 验证结果

- 编译产物：`Mach-O 64-bit executable arm64` ✅
- GPU 渲染：MoltenVK + Metal (Apple M5 Max) ✅
- Android 14 启动：`Successfully loaded snapshot 'default_boot'` ✅
