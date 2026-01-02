ARCHS = arm64
TARGET = iphone:clang:latest:13.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc -O3

# المكتبات الضرورية (يجب أن تتطابق معdylib الأصلي)
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security CoreGraphics QuartzCore AudioToolbox

# سطر السيادة: تأمين الذاكرة عبر محاذاة القطاعات وتشفير الروابط
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk

