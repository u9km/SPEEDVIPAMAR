ARCHS = arm64
TARGET = iphone:clang:latest:18.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m
# تعمية الكود وإخفاء البصمة البرمجية تماماً
SovereignSecurity_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden 
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security CoreGraphics CoreLocation

# تأمين قطاعات الذاكرة وحماية الكيرنال
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
