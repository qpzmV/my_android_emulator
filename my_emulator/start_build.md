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
python3 ./android/build/python/cmake.py
ninja

# 这会生成：
./external/qemu/objs/distribution/emulator/emulator

# 运行安卓虚拟机
## 安装安卓镜像
sdkmanager "system-images;android-34;google_apis_playstore;x86_64" 
## 创建虚拟机
avdmanager create avd -n Android14 -k "system-images;android-34;google_apis_playstore;x86_64" --device "pixel"
## 运行虚拟机
./external/qemu/objs/distribution/emulator/emulator -avd Android14 -gpu swiftshader_indirect

