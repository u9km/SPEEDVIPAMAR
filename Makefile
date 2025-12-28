# المعماريات المدعومة (تدعم جميع هواتف آيفون الحديثة)
ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

# إعدادات تحسين الأداء لضمان عدم حدوث لاغ (Lag)
DEBUG = 0
FINALPACKAGE = 1
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

# اسم المكتبة الناتجة (سيكون اسمها SecurityShield.dylib)
LIBRARY_NAME = SecurityShield

# ربط ملفات المشروع (تأكد أن الملفات بنفس المجلد)
SecurityShield_FILES = Tweak.x fishhook.c
SecurityShield_CFLAGS = -fobjc-arc -O3 -DNO_JAILBREAK=1
SecurityShield_LDFLAGS = -Wl,-undefined,dynamic_lookup
SecurityShield_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/library.mk
