TARGET := iphone:clang:latest:14.0
ARCHS = arm64
TWEAK_NAME = GCloudShield

GCloudShield_FILES = Tweak.x fishhook.c
GCloudShield_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
