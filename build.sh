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
export PATH="$OPPO_K10X_RootPath/compiler/ccache-bin:$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin:$OPPO_K10X_RootPath/compiler/aarch64-linux-android-9.3/bin:$OPPO_K10X_RootPath/compiler/arm-linux-androideabi-4.9/bin:$PATH"
export CROSS_COMPILE="aarch64-linux-android-"
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CLANG_PATH=$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin

# 修复汇编 -EL 参数报错：强制整套LLVM工具链，防止调用系统/usr/bin/as
export LLVM=1
export AS=llvm-as
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export STRIP=llvm-strip

# 生成基础defconfig
make O=out CC="clang" LLVM=1 k10x_defconfig

# WIFI驱动改为内置 CONFIG_QCA_CLD_WLAN=m → y
sed -i 's/^CONFIG_QCA_CLD_WLAN=m/CONFIG_QCA_CLD_WLAN=y/' out/.config
echo "===== WLAN配置检查 ====="
grep CONFIG_QCA_CLD_WLAN out/.config
echo "========================"

# 正式编译内核
make O=out CC="clang" LLVM=1 -j$(nproc)

# 模块收集逻辑（内置成功后不会生成wlan.ko，代码保留不影响编译流程）
ALL_MODULES_DIR="$OPPO_K10X_RootPath/kernel/msm-5.4/out/all_modules"
KERNEL_RELEASE=$(cat out/include/config/kernel.release)
FAKE_ROOT="$OPPO_K10X_RootPath/kernel/msm-5.4/out/fake_root"
FAKE_MOD_DIR="$FAKE_ROOT/lib/modules/$KERNEL_RELEASE"
mkdir -p "$ALL_MODULES_DIR"
mkdir -p "$FAKE_MOD_DIR"

find out -name "*.ko" -exec cp {} "$FAKE_MOD_DIR/" \;
find "$FAKE_MOD_DIR" -name "*.ko" -exec "$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin/llvm-strip" --strip-debug {} \;

cd "$FAKE_MOD_DIR"
[ -f wlan.ko ] && mv wlan.ko qca_cld3_wlan.ko
ls -1 *.ko > modules.load
cd "$(dirname "$0")"

depmod -b "$FAKE_ROOT" "$KERNEL_RELEASE"
mv "$FAKE_MOD_DIR/"* "$ALL_MODULES_DIR/"
rm -rf "$FAKE_ROOT"
