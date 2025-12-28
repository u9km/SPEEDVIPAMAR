# تعطيل التوقيع لتجاوز خطأ ldid (لأنك ستقوم بالتوقيع لاحقاً عند الحقن)
GO_EASY_ON_ME = 1
CODE_SIGNING_REQUIRED = NO

TARGET := iphone:clang:latest:12.0
ARCHS = arm64 arm64e
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SecurityShield

SecurityShield_FILES = Tweak.x fishhook.c
SecurityShield_CFLAGS = -fobjc-arc -O2 -Wno-deprecated-declarations

# إضافة هذا السطر لمنع ربط مكتبة CydiaSubstrate (لأن الأداة بدون جيلبريك)
SecurityShield_LDFLAGS += -Wl,-undefined,dynamic_lookup

include $(THEOS_MAKE_PATH)/tweak.mk
