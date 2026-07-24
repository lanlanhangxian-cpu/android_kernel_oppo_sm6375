#!/bin/bash

# 加载环境变量文件
如果 [ -z "$OPPO_K10X_RootPath" ]; 那么
    CONF_FILE="$(dirname "$(readlink -f "$0")")/env_vars.sh"
    如果 [ -f "$CONF_FILE" ]; 那么
源"$CONF_FILE"
    fi
fi

# 校验根路径变量（修复原脚本判断写反）
如果 [ -z "$OPPO_K10X_RootPath" ]; 那么
    echo "OPPO_K10X_RootPath 未定义。"
    exit 1
fi

# 工具链环境变量完全保留原样
export ARCH="arm64"
export SUBARCH="arm64"
export PATH="$OPPO_K10X_RootPath/compiler/ccache-bin:$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin:$OPPO_K10X_RootPath/compiler/aarch64-linux-android-9.3/bin:$OPPO_K10X_RootPath/compiler/arm-linux-androideabi-4.9/bin:$PATH"
export CROSS_COMPILE="aarch64-linux-android-"
export CROSS_COMPILE_ARM32="arm-linux-androideabi-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CLANG_PATH=$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin

# ====================== 批量将所有指定驱动改为内置编译(y) ======================
DEFCONFIG="${OPPO_K10X_RootPath}/kernel/msm-5.4/arch/arm64/configs/k10x_defconfig"
# 批量替换 CONFIG_XXX=m → CONFIG_XXX=y
sed -i 's/CONFIG_ADSP_LOADER_DLKM=m/CONFIG_ADSP_LOADER_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_APR=m/CONFIG_APR=y/' "$DEFCONFIG"
sed -i 's/CONFIG_APR_DLKM=m/CONFIG_APR_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_AW87XXX_DLKM=m/CONFIG_AW87XXX_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_AW882XX_DLKM=m/CONFIG_AW882XX_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_BOLERO_CDC_DLKM=m/CONFIG_BOLERO_CDC_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_BT_FM_SLIM=m/CONFIG_BT_FM_SLIM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_BTPOWER=m/CONFIG_BTPOWER=y/' "$DEFCONFIG"
sed -i 's/CONFIG_CAMERA=m/CONFIG_CAMERA=y/' "$DEFCONFIG"
sed -i 's/CONFIG_CDT_INTEGRITY=m/CONFIG_CDT_INTEGRITY=y/' "$DEFCONFIG"
sed -i 's/CONFIG_HORAE_SHELL_TEMP=m/CONFIG_HORAE_SHELL_TEMP=y/' "$DEFCONFIG"
sed -i 's/CONFIG_LAST_BOOT_REASON=m/CONFIG_LAST_BOOT_REASON=y/' "$DEFCONFIG"
sed -i 's/CONFIG_MACHINE_DLKM=m/CONFIG_MACHINE_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_MBHC_DLKM=m/CONFIG_MBHC_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_NATIVE_DLKM=m/CONFIG_NATIVE_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_OPLUS_BSP_IR_CORE=m/CONFIG_OPLUS_BSP_IR_CORE=y/' "$DEFCONFIG"
sed -i 's/CONFIG_OPLUS_BSP_KOOKONG_IR_SPI=m/CONFIG_OPLUS_BSP_KOOKONG_IR_SPI=y/' "$DEFCONFIG"
sed -i 's/CONFIG_OPLUS_BSP_MIDAS=m/CONFIG_OPLUS_BSP_MIDAS=y/' "$DEFCONFIG"
sed -i 's/CONFIG_OPLUS_WIFISMARTANTENNA=m/CONFIG_OPLUS_WIFISMARTANTENNA=y/' "$DEFCONFIG"
sed -i 's/CONFIG_PA_MANAGER_DLKM=m/CONFIG_PA_MANAGER_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_PINCTRL_LPI_DLKM=m/CONFIG_PINCTRL_LPI_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_PLATFORM_DLKM=m/CONFIG_PLATFORM_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_POLICY_ENGINE=m/CONFIG_POLICY_ENGINE=y/' "$DEFCONFIG"
sed -i 's/CONFIG_Q6_DLKM=m/CONFIG_Q6_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_Q6_NOTIFIER_DLKM=m/CONFIG_Q6_NOTIFIER_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_Q6_PDR_DLKM=m/CONFIG_Q6_PDR_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_QCA_CLD3_WLAN=m/CONFIG_QCA_CLD3_WLAN=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RDBG=m/CONFIG_RDBG=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RMNET_CORE=m/CONFIG_RMNET_CORE=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RMNET_CTL=m/CONFIG_RMNET_CTL=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RMNET_OFFLOAD=m/CONFIG_RMNET_OFFLOAD=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RMNET_SHS=m/CONFIG_RMNET_SHS=y/' "$DEFCONFIG"
sed -i 's/CONFIG_RX_MACRO_DLKM=m/CONFIG_RX_MACRO_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_SIA81XX_DLKM=m/CONFIG_SIA81XX_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_SND_EVENT_DLKM=m/CONFIG_SND_EVENT_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_SOUNDWIRE_BUS=m/CONFIG_SOUNDWIRE_BUS=y/' "$DEFCONFIG"
sed -i 's/CONFIG_STUB_DLKM=m/CONFIG_STUB_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_SWR_CTRL_DLKM=m/CONFIG_SWR_CTRL_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_SWR_DLKM=m/CONFIG_SWR_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_TFA98XX_V6_DLKM=m/CONFIG_TFA98XX_V6_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_TX_MACRO_DLKM=m/CONFIG_TX_MACRO_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_UFF_FP_DRIVER=m/CONFIG_UFF_FP_DRIVER=y/' "$DEFCONFIG"
sed -i 's/CONFIG_VA_MACRO_DLKM=m/CONFIG_VA_MACRO_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD937X_DLKM=m/CONFIG_WCD937X_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD937X_SLAVE_DLKM=m/CONFIG_WCD937X_SLAVE_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD938X_DLKM=m/CONFIG_WCD938X_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD938X_SLAVE_DLKM=m/CONFIG_WCD938X_SLAVE_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD9XXX_DLKM=m/CONFIG_WCD9XXX_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WCD_CORE_DLKM=m/CONFIG_WCD_CORE_DLKM=y/' "$DEFCONFIG"
sed -i 's/CONFIG_WSA881X_ANALOG_DLKM=m/CONFIG_WSA881X_ANALOG_DLKM=y/' "$DEFCONFIG"
# ======================================================================

# 原生编译命令无修改
make O=out CC="clang" LLVM=1 k10x_defconfig
make O=out CC="clang" LLVM=1 -j$(nproc)

# 下方全部保留你原有模块打包逻辑
ALL_MODULES_DIR="$OPPO_K10X_RootPath/kernel/msm-5.4/out/all_modules"
KERNEL_RELEASE=$(cat out/include/config/kernel.release)
FAKE_ROOT="$OPPO_K10X_RootPath/kernel/msm-5.4/out/fake_root"
FAKE_MOD_DIR="$FAKE_ROOT/lib/modules/$KERNEL_RELEASE"
mkdir -p "$ALL_MODULES_DIR"
mkdir -p "$FAKE_MOD_DIR"

# 过滤所有内置ko，不复制进模块目录（避免找不到文件报错）
find . -name "*.ko" \
! -name "adsp_loader_dlkm.ko" \
! -name "apr.ko" \
! -name "apr_dlkm.ko" \
! -name "aw87xxx_dlkm.ko" \
! -name "aw882xx_dlkm.ko" \
! -name "bolero_cdc_dlkm.ko" \
! -name "bt_fm_slim.ko" \
! -name "btpower.ko" \
! -name "camera.ko" \
! -name "cdt_integrity.ko" \
! -name "horae_shell_temp.ko" \
! -name "last_boot_reason.ko" \
! -name "machine_dlkm.ko" \
! -name "mbhc_dlkm.ko" \
! -name "native_dlkm.ko" \
! -name "oplus_bsp_ir_core.ko" \
! -name "oplus_bsp_kookong_ir_spi.ko" \
! -name "oplus_bsp_midas.ko" \
! -name "oplus_wifismartantenna.ko" \
! -name "pa_manager_dlkm.ko" \
! -name "pinctrl_lpi_dlkm.ko" \
! -name "platform_dlkm.ko" \
! -name "policy_engine.ko" \
! -name "q6_dlkm.ko" \
! -name "q6_notifier_dlkm.ko" \
! -name "q6_pdr_dlkm.ko" \
! -name "qca_cld3_wlan.ko" \
! -name "rdbg.ko" \
! -name "rmnet_core.ko" \
! -name "rmnet_ctl.ko" \
! -name "rmnet_offload.ko" \
! -name "rmnet_shs.ko" \
! -name "rx_macro_dlkm.ko" \
! -name "sia81xx_dlkm.ko" \
! -name "snd_event_dlkm.ko" \
! -name "soundwire-bus.ko" \
! -name "stub_dlkm.ko" \
! -name "swr_ctrl_dlkm.ko" \
! -name "swr_dlkm.ko" \
! -name "tfa98xx-v6_dlkm.ko" \
! -name "tx_macro_dlkm.ko" \
! -name "uff_fp_driver.ko" \
! -name "va_macro_dlkm.ko" \
! -name "wcd937x_dlkm.ko" \
! -name "wcd937x_slave_dlkm.ko" \
! -name "wcd938x_dlkm.ko" \
! -name "wcd938x_slave_dlkm.ko" \
! -name "wcd9xxx_dlkm.ko" \
! -name "wcd_core_dlkm.ko" \
! -name "wsa881x_analog_dlkm.ko" \
-exec cp {} "$FAKE_MOD_DIR/" \;

查找"$FAKE_MOD_DIR" -名称 “*.ko” -执行 "$OPPO_K10X_RootPath/compiler/clang-12.0.5/bin/llvm-strip" --剥离-调试 {} \;
cd "$FAKE_MOD_DIR"
# 所有wlan类驱动已内置，注释原wlan重命名语句，防止报错
# mv wlan.ko qca_cld3_wlan.ko
ls -1 *.ko > modules.load
cd "$(dirname "$0")"
depmod -b "$FAKE_ROOT" "$KERNEL_RELEASE"
mv "$FAKE_MOD_DIR/"* "$ALL_MODULES_DIR/"
删除-rf "$FAKE_ROOT"
