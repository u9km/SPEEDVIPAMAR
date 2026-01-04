ARCHS = arm64
TARGET = iphone:clang:latest:18.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden # إخفاء الرموز لمنع IDA من قراءة الكود
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security CoreGraphics QuartzCore

# تأمين الذاكرة وحماية SBC العميقة
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
