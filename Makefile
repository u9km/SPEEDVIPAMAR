# Makefile
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m MemoryExploiter.m
SovereignSecurity_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
