TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GCloudShield

GCloudShield_FILES = Tweak.x fishhook.c
GCloudShield_CFLAGS = -fobjc-arc
GCloudShield_LDFLAGS = -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

