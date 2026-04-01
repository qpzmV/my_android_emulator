#!/bin/bash
cd my_emulator/prebuilts/android-emulator-build/qt/darwin-x86_64/lib && for f in *.tgz; do tar -zxvf "$f"; done && cd -
cd my_emulator/prebuilts/clang/host/darwin-x86/clang-r530567/bin && for f in *.tgz; do tar -zxvf "$f"; done && cd -
cd my_emulator/prebuilts/clang/host/darwin-x86/clang-r530567/lib && for f in *.tgz; do tar -zxvf "$f"; done && cd -
