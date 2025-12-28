ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

DEBUG = 0
FINALPACKAGE = 1
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = SecurityShieldVIP

# ربط ملفات المشروع
SecurityShieldVIP_FILES = Tweak.x fishhook.c
SecurityShieldVIP_CFLAGS = -fobjc-arc -O3 -DNO_JAILBREAK=1
SecurityShieldVIP_LDFLAGS = -Wl,-undefined,dynamic_lookup
SecurityShieldVIP_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/library.mk
