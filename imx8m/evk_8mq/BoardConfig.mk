#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MQ
BOARD_TYPE := EVK
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := false
BOARD_KERNEL_BASE := 0x40400000
TARGET_GRALLOC_VERSION := v3
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
USE_OPENGL_RENDERER := true
TARGET_HAVE_VULKAN := true
ENABLE_CFI=false

SOONG_CONFIG_IMXPLUGIN += \
                          BOARD_HAVE_VPU \
                          BOARD_VPU_TYPE

SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MQ
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_ONLY = false

#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/nxp/imx8m/evk_8mq

include device/nxp/imx8m/BoardConfigCommon.mk

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.nxp

# Support gpt
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  BOARD_BPT_INPUT_FILES += device/nxp/common/partition/device-partitions-13GB-ab_super.bpt
  ADDITION_BPT_PARTITION = partition-table-28GB:device/nxp/common/partition/device-partitions-28GB-ab_super.bpt \
                           partition-table-dual:device/nxp/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt \
                           partition-table-28GB-dual:device/nxp/common/partition/device-partitions-28GB-ab-dual-bootloader_super.bpt
else
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    BOARD_BPT_INPUT_FILES += device/nxp/common/partition/device-partitions-13GB-ab-no-product.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/nxp/common/partition/device-partitions-28GB-ab-no-product.bpt \
                             partition-table-dual:device/nxp/common/partition/device-partitions-13GB-ab-dual-bootloader-no-product.bpt \
                             partition-table-28GB-dual:device/nxp/common/partition/device-partitions-28GB-ab-dual-bootloader-no-product.bpt
  else
    BOARD_BPT_INPUT_FILES += device/nxp/common/partition/device-partitions-13GB-ab.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/nxp/common/partition/device-partitions-28GB-ab.bpt \
                             partition-table-dual:device/nxp/common/partition/device-partitions-13GB-ab-dual-bootloader.bpt \
                             partition-table-28GB-dual:device/nxp/common/partition/device-partitions-28GB-ab-dual-bootloader.bpt
  endif
endif

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := EVK

USE_OPENGL_RENDERER := true

BOARD_WLAN_DEVICE            := nxp
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB           := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB    := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# NXP 8997 BT
BOARD_HAVE_BLUETOOTH_NXP := true

BOARD_USE_SENSOR_FUSION := true

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

BOARD_HAVE_USB_CAMERA := true
BOARD_HAVE_USB_MJPEG_CAMERA := false

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/nxp/common/security/testkey_rsa4096.pem

BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 2

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=1280M
endif

# NXP default config
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttymxc0 androidboot.hardware=nxp firmware_class.path=/vendor/firmware loop.max_part=7

# framebuffer config
BOARD_KERNEL_CMDLINE += androidboot.fbTileSupport=enable

# memory config
BOARD_KERNEL_CMDLINE += transparent_hugepage=never cma=$(CMASIZE)

# display config
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=240 androidboot.primary_display=imx-dcss androidboot.gui_resolution=1080p

# wifi config
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN moal.mod_para=wifi_mod_para.conf

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
BOARD_KERNEL_CMDLINE += androidboot.vendor.sysrq=1
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_8mq/dtbo-imx8mq.img
ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-product.dtb
  else
    # imx8mq with HDMI display
    TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-pcie1-m2.dtb
    # imx8mq with MIPI-HDMI display
    TARGET_BOARD_DTS_CONFIG += imx8mq-mipi:imx8mq-evk-lcdif-adv7535.dtb
    # imx8mq with HDMI and MIPI-HDMI display
    TARGET_BOARD_DTS_CONFIG += imx8mq-dual:imx8mq-evk-dual-display.dtb
    # imx8mq with MIPI panel display
    TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel:imx8mq-evk-dcss-rm67191.dtb
  endif
else # no dynamic parition feature
  ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
    TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-product-no-dynamic_partition.dtb
  else
	TARGET_BOARD_DTS_CONFIG ?= imx8mq:imx8mq-evk-no-dynamic_partition.dtb
  endif
endif

BOARD_SEPOLICY_DIRS := \
       device/nxp/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       $(IMX_DEVICE_PATH)/sepolicy_drm
endif

TARGET_BOARD_KERNEL_HEADERS := device/nxp/common/kernel-headers

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

BOARD_USES_METADATA_PARTITION := true
BOARD_ROOT_EXTRA_FOLDERS += metadata
