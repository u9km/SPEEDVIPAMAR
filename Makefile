ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

# نستخدم ملف واحد فقط لأننا دمجنا كل شيء فيه
SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_FRAMEWORKS = UIKit CoreML Foundation Security
SovereignSecurity_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
