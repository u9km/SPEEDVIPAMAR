TARGET := iphone:clang:latest:13.0
ARCHS := arm64 arm64e

THEOS_PACKAGE_SCHEME = rootless
INSTALL_TARGET_PROCESSES = YourAppName

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc
SovereignSecurity_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
