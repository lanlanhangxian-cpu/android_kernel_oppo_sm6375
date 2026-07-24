#!/bin/bash

# 加载环境变量
if [ -z "$OPPO_K10X_RootPath" ]; then
    CONF_FILE="$(dirname "$(readlink -f "$0")")/env_vars.sh"
    if [ -f "$CONF_FILE" ]; then
        source "$CONF_FILE"
    fi
fi

# 修复原脚本判断写反的错误
if [ -z "$OPPO_K10X_RootPath" ]; then
    echo "OPPO_K10X_RootPath 未定义。"
    exit 1
fi

# 完整保留你原版所有环境导出
export ARCH="arm64"
export SUBARCH="arm64"
export PATH="$OPPO_K10X_RootPath/compiler/ccache-bin:$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin:$OPPO_K10X_RootPath/compiler/aarch64-linux-android-9.3/bin:$OPPO_K10X_RootPath/compiler/arm-linux-androideabi-4.9/bin:$PATH"
export CROSS_COMPILE="aarch64-linux-android-"
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CLANG_PATH=$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin

# ==========新增：将wlan驱动编译进内核镜像==========
DEFCONFIG_PATH="${OPPO_K10X_RootPath}/kernel/msm-5.4/arch/arm64/configs/k10x_defconfig"
# 将wlan驱动从模块(m)改为内置(y)
sed -i 's/CONFIG_QCA_CLD3_WLAN=m/CONFIG_QCA_CLD3_WLAN=y/' "$DEFCONFIG_PATH"
# ==================================================

# 你的原版编译命令无改动
make O=out CC="clang" LLVM=1 k10x_defconfig
make O=out CC="clang" LLVM=1 -j$(nproc)

# 下面全部是你原本的模块打包逻辑，仅做两处兼容修改防止报错
ALL_MODULES_DIR="$OPPO_K10X_RootPath/kernel/msm-5.4/out/all_modules"
KERNEL_RELEASE=$(cat out/include/config/kernel.release)
FAKE_ROOT="$OPPO_K10X_RootPath/kernel/msm-5.4/out/fake_root"
FAKE_MOD_DIR="$FAKE_ROOT/lib/modules/$KERNEL_RELEASE"
mkdir -p "$ALL_MODULES_DIR"
mkdir -p "$FAKE_MOD_DIR"

# 过滤已内置的wlan ko，不再复制（避免找不到文件）
find . -name "*.ko" ! -path "*qca_cld3_wlan.ko" -exec cp {} "$FAKE_MOD_DIR/" \;

查找$FAKE_MOD_DIR" -名称 "*.ko" -执行 "$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin/llvm-strip" --剥离-调试 {} \;
cd "$FAKE_MOD_DIR"
# wlan已内置无ko，注释原mv命令，防止报错
# mv wlan.ko qca_cld3_wlan.ko
ls -1 *.ko > modules.load
cd "$(dirname "$0")"
depmod -b "$FAKE_ROOT" "$KERNEL_RELEASE"
mv "$FAKE_MOD_DIR/"* "$ALL_MODULES_DIR/"
rm -rf "$FAKE_ROOT"
