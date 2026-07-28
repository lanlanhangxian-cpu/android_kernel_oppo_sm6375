#!/bin/bash

CONF_FILE="$(dirname "$(readlink -f "$0")")/env_vars.sh"
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
fi

if [ -z "$OPPO_K10X_RootPath" ]; then
    echo "OPPO_K10X_RootPath 未定义。"
    exit 1
fi

export ARCH="arm64"
export SUBARCH="arm64"
export PATH="$OPPO_K10X_RootPath/compiler/aarch64-linux-android-9.3/bin:$OPPO_K10X_RootPath/compiler/arm-linux-androideabi-4.9/bin:$PATH"
export CROSS_COMPILE="aarch64-linux-android-"
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"

# 【关键】暂时从PATH移除clang目录，杜绝意外调用clang！
unset CLANG_TRIPLE
unset CLANG_PATH

# 完整删除旧构建目录，清除全部clang残留编译缓存
rm -rf out

# GCC纯交叉编译，不涉及clang
make O=out CROSS_COMPILE=${CROSS_COMPILE} k10x_defconfig

# WIFI尝试内置
sed -i 's/^CONFIG_QCA_CLD_WLAN=m/CONFIG_QCA_CLD_WLAN=y/' out/.config
echo "===== WLAN配置检查 ====="
grep CONFIG_QCA_CLD_WLAN out/.config
echo "========================"

make O=out CROSS_COMPILE=${CROSS_COMPILE} -j$(nproc)

# 模块打包逻辑
ALL_MODULES_DIR="$OPPO_K10X_RootPath/kernel/msm-5.4/out/all_modules"
KERNEL_RELEASE=$(cat out/include/config/kernel.release)
FAKE_ROOT="$OPPO_K10X_RootPath/kernel/msm-5.4/out/fake_root"
FAKE_MOD_DIR="$FAKE_ROOT/lib/modules/$KERNEL_RELEASE"
mkdir -p "$ALL_MODULES_DIR"
mkdir -p "$FAKE_MOD_DIR"

find out -name "*.ko" -exec cp {} "$FAKE_MOD_DIR/" \;
STRIP_BIN="${OPPO_K10X_RootPath}/compiler/aarch64-linux-android-9.3/bin/aarch64-linux-android-strip"
find "$FAKE_MOD_DIR" -name "*.ko" -exec "${STRIP_BIN}" --strip-debug {} \;

cd "$FAKE_MOD_DIR"
[ -f wlan.ko ] && mv wlan.ko qca_cld3_wlan.ko
ls -1 *.ko > modules.load
cd "$(dirname "$0")"

depmod -b "$FAKE_ROOT" "$KERNEL_RELEASE"
mv "$FAKE_MOD_DIR/"* "$ALL_MODULES_DIR/"
rm -rf "$FAKE_ROOT"
