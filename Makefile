# إعدادات الهدف: آيفون، آخر إصدار SDK، ودعم iOS 12.0 فما فوق
TARGET := iphone:clang:latest:12.0

# المعماريات المدعومة (أجهزة 64-bit)
ARCHS = arm64 arm64e

# تحسينات للأداء وتقليل الحجم (نسخة نهائية)
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم الأداة (يجب أن يطابق اسم ملف الـ plist)
TWEAK_NAME = SecurityShield

# ملفات المشروع: الكود الأساسي + مكتبة fishhook
SecurityShield_FILES = Tweak.x fishhook.c

# أعلام المترجم: تفعيل ARC، وتحسين السرعة (-O2)
SecurityShield_CFLAGS = -fobjc-arc -O2 -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk
