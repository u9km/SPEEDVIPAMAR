# إعدادات البناء بدون جلبريك
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

# تأكد من استخدام مكتبات متوافقة مع السايدلود
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc
SovereignSecurity_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
