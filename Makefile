ARCHS = arm64
TARGET = iphone:clang:latest:13.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc -O3

# [span_18](start_span)المكتبات الضرورية للرسم، التشفير، والذاكرة[span_18](end_span)
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics AudioToolbox

# [span_19](start_span)سطر السيادة: تأمين الذاكرة عبر محاذاة القطاعات وتشفير الروابط[span_19](end_span)
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
