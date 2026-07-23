#!/bin/bash
设置 

 [ -z "$OPPO_K10X_RootPath" ]; 然后
    CONF_FILE="$(dirname "$(readlink -f "$0")")/env_vars.sh"
    如果 [ -f "$CONF_FILE" ]; 那么
源"$CONF_FILE"
    fi
fi

如果 [ "$OPPO_K10X_RootPath" ]; 那么
echo"OPPO_K10X_RootPath 未定义。"
    exit 1
fi

export ARCH="arm64"
export SUBARCH="arm64"
export PATH="$OPPO_K10X_RootPath/compiler/ccache-bin:$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin:$OPPO_K10X_RootPath/compiler/aarch64-linux-android-9.3/bin:$OPPO_K10X_RootPath/compiler/arm-linux-androideabi-4.9/bin:$PATH"
export CROSS_COMPILE="aarch64-linux-android-"
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CLANG_PATH=$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin

make O=out CC="clang" LLVM=1 k10x_defconfig
make O=out CC="clang" LLVM=1 -j$(nproc)

ALL_MODULES_DIR="$OPPO_K10X_RootPath/kernel/msm-5.4/out/all_modules"
KERNEL_RELEASE=$(cat out/include/config/kernel.release)
FAKE_ROOT="$OPPO_K10X_RootPath/kernel/msm-5.4/out/fake_root"
FAKE_MOD_DIR="$FAKE_ROOT/lib/modules/$KERNEL_RELEASE"
mkdir -p "$ALL_MODULES_DIR"
mkdir -p "$FAKE_MOD_DIR"
查找当前目录。-name "*.ko" -exec cp {} "$FAKE_MOD_DIR/" \;
查找"$FAKE_MOD_DIR" -name "*.ko" -exec "$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin/llvm-strip" --strip-debug {} \;
cd "$FAKE_MOD_DIR"
mv wlan.ko qca_cld3_wlan.ko
ls -1 *.ko > modules.load
cd "$(dirname "$0")"
depmod -b "$FAKE_ROOT" "$KERNEL_RELEASE"
mv "$FAKE_MOD_DIR/"* "$ALL_MODULES_DIR/"
rm -rf "$FAKE_ROOT"
