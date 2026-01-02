ARCHS = arm64
TARGET = iphone:clang:latest:13.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc -O3

# [span_28](start_span)المكتبات الضرورية (تم مطابقتها معdylib الأصلي)[span_28](end_span)
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security CoreGraphics QuartzCore AudioToolbox

# [span_29](start_span)تأمين الذاكرة ومنع الكشف عبر محاذاة القطاعات وتشفير الروابط[span_29](end_span)
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
