# إعدادات الهدف والمعمارية
TARGET := iphone:clang:latest:14.5
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

# اسم التويك (يجب أن يتطابق مع الملفات الأخرى)
TWEAK_NAME = SecurityShield

# الملفات المطلوبة للبناء (تأكد من تسمية Tweak.x بهذا الاسم بالضبط)
SecurityShield_FILES = Tweak.x fishhook.c

# إعدادات المترجم
SecurityShield_CFLAGS = -fobjc-arc -O3

include $(THEOS_MAKE_PATH)/tweak.mk
