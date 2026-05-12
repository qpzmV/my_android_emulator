# 安装 repo
mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod +x ~/bin/repo
export PATH=~/bin:$PATH

# 拉源码
mkdir ~/emu-src
cd ~/emu-src
repo init -u https://android.googlesource.com/platform/manifest -b emu-master-dev
repo sync -j8

# 然后：
cd external/qemu
python3 ./android/build/python/cmake.py --target darwin-aarch64
ninja

# 这会生成：
./external/qemu/objs/distribution/emulator/emulator

# 运行安卓虚拟机
## 安装安卓镜像（ARM64 Mac 必须用 arm64-v8a 镜像）
sdkmanager "system-images;android-34;default;arm64-v8a"
## 创建虚拟机
avdmanager create avd -n Android14_ARM -k "system-images;android-34;default;arm64-v8a" --device "pixel"
## 运行虚拟机（ARM64 Mac 必须用 -gpu host）
export ANDROID_SDK_ROOT=/opt/homebrew/share/android-commandlinetools
./external/qemu/objs/distribution/emulator/emulator -avd Android14_ARM -gpu host -dns-server 8.8.8.8,1.1.1.1


