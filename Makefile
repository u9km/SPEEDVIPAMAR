# إعدادات المعمارية والهدف
TARGET := iphone:clang:latest:13.0
ARCHS := arm64 arm64e
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

SovereignSecurity_FILES = SovereignSecurity.m
# أعلام التشفير والتمويه:
# -O3: تعتيم منطق الكود
# -fvisibility=hidden: إخفاء الدوال عن الفحص الخارجي
SovereignSecurity_CFLAGS = -fobjc-arc -O3 -fvisibility=hidden

# أعلام الربط لإخفاء الهوية:
# -Wl,-S: حذف كافة الرموز (Full Symbol Stripping)
SovereignSecurity_LDFLAGS = -Wl,-S -Wl,-segalign,4000

SovereignSecurity_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
