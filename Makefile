TARGET := iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GCloudShield

# دمج ملف التويك مع مكتبة فيشهوك
GCloudShield_FILES = Tweak.x fishhook.c
GCloudShield_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
