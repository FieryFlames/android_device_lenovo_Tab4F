#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(USES_DEVICE_LENOVO_TAB4F),true)
include $(call all-makefiles-under,$(LOCAL_PATH))

endif
