TARGET := iphone:clang:latest:13.0
ARCHS = arm64
TWEAK_NAME = GCloudShield

GCloudShield_FILES = Tweak.x fishhook.c
GCloudShield_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
