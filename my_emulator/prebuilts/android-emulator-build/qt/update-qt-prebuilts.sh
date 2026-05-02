#!/bin/bash

DRY_RUN=
function run() {
    if [ -z "$DRY_RUN" ]; then
        echo "RUN: $@"
        $@
    else
        echo "DRY_RUN: $@"
    fi
}

function print_help() {
    echo -e "\nUsage: update-qt-prebuilts.sh [-t|--target TARGET] [--dry-run] BUILD_NUMBER"
    echo -e "\nArguments:"
    echo "  BUILD_NUMBER: The build number from aosp-emu-prebuilts branch."
    echo "  --dry-run: Dump all commands, but don't execute them."
    echo "  -t, --target TARGET: A specific target to update, otherwise updates all targets."
    echo "                       Valid targets: prebuilts-linux_x64,"
    echo "                                      prebuilts-mac_aarch64,"
    echo "                                      prebuilts-mac_x64,"
    echo "                                      prebuilts-windows_x64"
}

PROGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
BUILD_TARGETS="prebuilts-linux_x64 prebuilts-mac_aarch64 prebuilts-mac_x64 prebuilts-windows_x64"
BUILD_NUMBER=
TARGET=


while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_help
            exit 0
            ;;
        --dry-run)
            DRY_RUN=$1
            shift
            ;;
        -t|--target)
            shift
            case $1 in
                prebuilts-linux_x64)
                    ;&
                prebuilts-mac_aarch64)
                    ;&
                prebuilts-mac_x64)
                    ;&
                prebuilts-windows_x64)
                  TARGET=$1
                  shift
                ;;
              *)
                  echo "ERROR: Invalid target [$1]"
                  print_help
                  exit 1
                  ;;
              esac
              ;;
        *)
            BUILD_NUMBER=$1
            shift
            ;;
    esac
done

if [ -z "$BUILD_NUMBER" ]; then
     echo "ERROR: No build number provided."
     print_help
     exit 1
fi

run rm -rf "$PROGDIR/common/include/*"
run rm -rf "$PROGDIR/tmp"

if [ ! -z "$TARGET" ]; then
    BUILD_TARGETS="$TARGET"
fi

for target in $BUILD_TARGETS; do
    run mkdir $PROGDIR/tmp
    run cd $PROGDIR/tmp
    echo "Grabbing prebuilts for $target target.."
    case $target in
        prebuilts-linux_x64)
            zipfile=sdk-repo-linux-prebuilts-$BUILD_NUMBER.zip
            run rm -rf $PROGDIR/linux-aarch64 $PROGDIR/linux-aarch64-nowebengine $PROGDIR/linux-x86_64 $PROGDIR/linux-x86_64-nowebengine
            run ln -sf linux-aarch64 $PROGDIR/linux-aarch64-nowebengine
            run /google/data/ro/projects/android/fetch_artifact --bid $BUILD_NUMBER --target $target "$zipfile"
            run unzip $zipfile

            run mv $PROGDIR/tmp/qt $PROGDIR/linux-x86_64
            run mv $PROGDIR/tmp/qt-nowebengine $PROGDIR/linux-x86_64-nowebengine
            run mv $PROGDIR/tmp/qt-nowebengine-linux_aarch64 $PROGDIR/linux-aarch64
            ;;
        prebuilts-mac_aarch64)
            zipfile=sdk-repo-darwin_aarch64-prebuilts-$BUILD_NUMBER.zip
            run rm -rf $PROGDIR/darwin-aarch64-nowebengine $PROGDIR/darwin-aarch64
            run /google/data/ro/projects/android/fetch_artifact --bid $BUILD_NUMBER --target $target "$zipfile"
            run unzip $zipfile

            run mv $PROGDIR/tmp/qt $PROGDIR/darwin-aarch64
            run mv $PROGDIR/tmp/qt-nowebengine $PROGDIR/darwin-aarch64-nowebengine
            ;;
        prebuilts-mac_x64)
            zipfile=sdk-repo-darwin-prebuilts-$BUILD_NUMBER.zip
            run rm -rf $PROGDIR/darwin-x86_64-nowebengine $PROGDIR/darwin-x86_64
            run /google/data/ro/projects/android/fetch_artifact --bid $BUILD_NUMBER --target $target "$zipfile"
            run unzip $zipfile

            run mv $PROGDIR/tmp/qt $PROGDIR/darwin-x86_64
            run mv $PROGDIR/tmp/qt-nowebengine $PROGDIR/darwin-x86_64-nowebengine
            ;;
        prebuilts-windows_x64)
            zipfile=sdk-repo-windows-prebuilts-$BUILD_NUMBER.zip
            run rm -rf $PROGDIR/windows_msvc-x86_64
            run /google/data/ro/projects/android/fetch_artifact --bid $BUILD_NUMBER --target $target "$zipfile"
            run unzip $zipfile

            run mv $PROGDIR/tmp/qt $PROGDIR/windows_msvc-x86_64
            ;;
    esac
    run rm -rf $PROGDIR/tmp
done
echo "Finished Qt prebuilts update to build $BUILD_NUMBER"
