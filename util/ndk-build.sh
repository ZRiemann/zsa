#!/bin/bash

ndk_dir=~/Android/Sdk/ndk-bundle
proj_dir=.
verbose=1
app_platform=android-22
abi=armeabi-v7a
# V=1 Launch build, and display build commands
# -B Force a complete rebuild
# NDK_LOG=1
# NDK_DEBUG=1 Force a debuggable build
# NDK_HOST_32BIT=1 Always use the toolchain in 32-bit mode
# NDK_APPLICATION_MK=<file> Build, using a specific Application.mk file
# -C <project> Build the native code for the project path located at <project>

if [ "2" = "$#" ]; then
    proj_dir=$1
fi

${ndk_dir}/ndk-build V=${verbose} NDK_PROJECT_PATH=${proj_dir} APP_BUILD_SCRIPT=${proj_dir}/Android.mk APP_PLATFORM=${app_platform} APP_ABI=${abi}

exit 0