# استهداف iOS 11 وما فوق لضمان التوافق مع كل الأجهزة
TARGET := iphone:clang:latest:11.0
ARCHS := arm64

# نمط البناء بدون روت (مهم للحقن)
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

# الملفات المستخدمة
SovereignSecurity_FILES = SovereignSecurity.m

# أعلام المترجم (لضمان السرعة والتوافق)
SovereignSecurity_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

# مكتبات النظام المطلوبة
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security

include $(THEOS_MAKE_PATH)/tweak.mk
