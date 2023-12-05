#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Kernel
TARGET_USES_MITHORIUM_KERNEL := true

# Partitions
SSI_PARTITIONS := product system system_ext
TREBLE_PARTITIONS := odm vendor
ALL_PARTITIONS := $(SSI_PARTITIONS) $(TREBLE_PARTITIONS)

$(foreach p, $(call to-upper, $(ALL_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := ext4) \
    $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

# Inherit from common mithorium-common
include device/xiaomi/mithorium-common/BoardConfigCommon.mk

DEVICE_PATH := device/lenovo/Tab4F
USES_DEVICE_LENOVO_TAB4F := true

# Asserts
TARGET_OTA_ASSERT_DEVICE := Tab4F,Tab4F_4_19

# Bootanimation
TARGET_BOOTANIMATION_HALF_RES := true

# Camera
ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_SUPPORT_HAL1 := false
endif

# Display
TARGET_SCREEN_DENSITY := 400

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):init_lenovo_tab4f
TARGET_RECOVERY_DEVICE_MODULES := init_lenovo_tab4f

# Kernel
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/7824900.sdhci

ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_KERNEL_CONFIG += \
    vendor/msm8937-legacy.config
endif
TARGET_KERNEL_CONFIG += \
    vendor/qualcomm/msm8937/qrd.config

ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_KERNEL_RECOVERY_CONFIG += \
    vendor/msm8937-legacy.config
endif
TARGET_KERNEL_RECOVERY_CONFIG += \
    vendor/qualcomm/msm8937/qrd.config

# Partitions
BOARD_USES_METADATA_PARTITION := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10332634112 # 10332650496 - 16384

# Partitions - dynamic
BOARD_SUPER_PARTITION_BLOCK_DEVICES := system
BOARD_SUPER_PARTITION_METADATA_DEVICE := system
BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3221225472
BOARD_SUPER_PARTITION_SIZE := $(BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE)

BOARD_SUPER_PARTITION_GROUPS := tab4f_dynpart
BOARD_TAB4F_DYNPART_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304 )
BOARD_TAB4F_DYNPART_PARTITION_LIST := $(ALL_PARTITIONS)

# Partitions - reserved size
$(foreach p, $(call to-upper, $(SSI_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_EXTFS_INODE_COUNT := -1))
$(foreach p, $(call to-upper, $(TREBLE_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_EXTFS_INODE_COUNT := 4096))

$(foreach p, $(call to-upper, $(SSI_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := 83886080)) # 80 MB
$(foreach p, $(call to-upper, $(TREBLE_PARTITIONS)), \
    $(eval BOARD_$(p)IMAGE_PARTITION_RESERVED_SIZE := 41943040)) # 40 MB

ifneq ($(WITH_GMS),true)
BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 314572800 # 300 MB
endif

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
ifeq ($(TARGET_KERNEL_VERSION),4.19)
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab_4_19.qcom
else
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab_4_9.qcom
endif

# Rootdir
SOONG_CONFIG_NAMESPACES += LENOVO_TAB4F_ROOTDIR
SOONG_CONFIG_LENOVO_TAB4F_ROOTDIR := KERNEL_VERSION
ifeq ($(TARGET_KERNEL_VERSION),4.19)
SOONG_CONFIG_LENOVO_TAB4F_ROOTDIR_KERNEL_VERSION := k4_19
else
SOONG_CONFIG_LENOVO_TAB4F_ROOTDIR_KERNEL_VERSION := k4_9
endif

# Security patch level
VENDOR_SECURITY_PATCH := 2022-02-01

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Inherit from the proprietary version
# TODO: Rebrand this?
include vendor/qualcomm/msm8937/BoardConfigVendor.mk
#-include vendor/private/custom-camera/msm8937/board.mk
