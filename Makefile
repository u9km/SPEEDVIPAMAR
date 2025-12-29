TARGET := iphone:clang:latest:13.0

ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard

THEOS_PACKAGE_SCHEME = rootless

export ADDITIONAL_CFLAGS = -Wno-unused-variable

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/tweak.mk
