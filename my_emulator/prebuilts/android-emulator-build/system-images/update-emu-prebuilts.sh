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
    echo -e "\nUsage: update-emu-prebuilts.sh [--dry-run] BUILD_NUMBER"
    echo -e "\nArguments:"
    echo "  BUILD_NUMBER: The build number from an emulator branch."
    echo "  --dry-run: Dump all commands, but don't execute them."
}

PROGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OS_TYPES="linux windows darwin darwin_aarch64"
BUILD_NUMBER=

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

run rm -rf "$PROGDIR/linux/emulators/*"
run rm -rf "$PROGDIR/windows/emulators/*"
run rm -rf "$PROGDIR/darwin/emulators/*"

#/google/data/ro/projects/android/fetch_artifact --bid 11525734 --target emulator-linux_x64_gfxstream 'sdk-repo-linux-emulator-11525734.zip'
for os_type in $OS_TYPES; do
    echo "**** Updating $os_type emulator prebuilts to $BUILD_NUMBER..."
    zip_name="sdk-repo-$os_type-emulator-$BUILD_NUMBER.zip"

    emu_dir=
    dst_zip_name=
    case $os_type in
      darwin_aarch64)
          emu_dir=$PROGDIR/darwin/emulators/$BUILD_NUMBER
          dst_zip_name="emulator-$os_type-$BUILD_NUMBER.zip"
          ;;
      *)
          emu_dir=$PROGDIR/$os_type/emulators/$BUILD_NUMBER
          dst_zip_name="emulator-${os_type}_x64-$BUILD_NUMBER.zip"
          ;;
    esac

    target=
    case $os_type in
      linux)
          ;&
      windows)
          target="emulator-${os_type}_x64_gfxstream"
          ;;
      darwin)
          target="emulator-mac_x64_gfxstream"
          ;;
      darwin_aarch64)
          target="emulator-mac_aarch64_gfxstream"
          ;;
    esac

    run mkdir $emu_dir
    run cd $emu_dir
    run /google/data/ro/projects/android/fetch_artifact --bid $BUILD_NUMBER --target $target "$zip_name"
    run mv "$zip_name" "$dst_zip_name"
    echo "**** Update done $os_type emulator prebuilts to $BUILD_NUMBER"
done
echo "Finished emulator prebuilts update to build $BUILD_NUMBER"
