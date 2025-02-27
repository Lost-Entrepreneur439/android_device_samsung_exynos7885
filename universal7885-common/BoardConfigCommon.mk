COMMON_PATH := device/samsung/universal7885-common

BOARD_VENDOR := samsung

# Platform
TARGET_BOARD_PLATFORM := $(subst exynos,universal,$(TARGET_SOC))
TARGET_BOOTLOADER_BOARD_NAME := $(TARGET_SOC)

include hardware/samsung_slsi-linaro/config/BoardConfig7885.mk

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Architecture
ifeq ($(TARGET_DEVICE),a10dd)
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a53
TARGET_USES_64_BIT_BINDER := true
else
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53
endif

# Bluetooth
BOARD_HAVE_BLUETOOTH_SLSI := true

# Build system
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_VINTF_PRODUCT_COPY_FILES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_ENFORCE_SYSPROP_OWNER := true

# Camera - libhwjpeg, unset it to enable guard
TARGET_USES_UNIVERSAL_LIBHWJPEG :=

# Display
BOARD_MINIMUM_DISPLAY_BRIGHTNESS := 1

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

# Fingerprint
ifneq ($(TARGET_HAS_UDFPS),true)
TARGET_SEC_FP_HAS_FINGERPRINT_GESTURES := true
endif

# Init
TARGET_INIT_VENDOR_LIB := //$(COMMON_PATH):libinit_universal7885

# Kernel
TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_ADDITIONAL_FLAGS += LD=ld.lld AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := androidboot.init_fatal_reboot_target=recovery
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100
TARGET_KERNEL_SOURCE := kernel/samsung/exynos7885
KERNEL_SUPPORTS_LLVM_TOOLS := true
TARGET_KERNEL_OPTIONAL_LD := true
TARGET_KERNEL_ADDITIONAL_FLAGS += HOSTCFLAGS="-fuse-ld=lld -Wno-unused-command-line-argument"

BOARD_USES_METADATA_PARTITION := true

# Keymaster
TARGET_KEYMASTER_VARIANT := samsung

# Camera
ifneq ($(TARGET_DEVICE),a10)
SOONG_CONFIG_NAMESPACES += samsungCameraVars
SOONG_CONFIG_samsungCameraVars += extra_ids
SOONG_CONFIG_samsungCameraVars_extra_ids := 50
endif
$(call soong_config_set,samsungCameraVars,usage_64bit,true)

# HIDL
include device/samsung/universal7885-common/configs/vintf/manifest.mk

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 37748736
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
TARGET_VENDOR_PROP += $(COMMON_PATH)/vendor.prop
TARGET_SYSTEM_PROP += $(COMMON_PATH)/system.prop
ifeq ($(TARGET_ARCH),arm64)
TARGET_VENDOR_PROP += $(COMMON_PATH)/configs/vendor_64.prop
else
TARGET_VENDOR_PROP += $(COMMON_PATH)/configs/vendor_32.prop
endif

# Recovery
BOARD_HAS_DOWNLOAD_MODE := true
TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/rootdir/etc/recovery.fstab

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(COMMON_PATH)/releasetools

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

BOARD_ROOT_EXTRA_FOLDERS := factory
BOARD_ROOT_EXTRA_SYMLINKS := /factory:/efs

BOARD_SEPOLICY_TEE_FLAVOR := teegris
include device/samsung_slsi/sepolicy/sepolicy.mk
include hardware/samsung-ext/interfaces/sepolicy/SEPolicy.mk

# Sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += \
    $(COMMON_PATH)/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    $(COMMON_PATH)/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(COMMON_PATH)/sepolicy/private

# Vendor
TARGET_COPY_OUT_VENDOR := vendor

# Wifi
BOARD_WLAN_DEVICE                := slsi
WPA_SUPPLICANT_VERSION           := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true

# wpa_supplicant feature flags
CONFIG_ACS := true
CONFIG_IEEE80211AC := true

# Vibrator
$(call soong_config_set,samsungVibratorVars,duration_amplitude,true)
