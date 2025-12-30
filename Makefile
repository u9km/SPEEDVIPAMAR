# استهداف معمارية 64-بت فقط (المستخدمة في ببجي)
TARGET := iphone:clang:latest:12.0
ARCHS := arm64

# نمط الروتلس (مهم للحقن)
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity

SovereignSecurity_FILES = SovereignSecurity.m
SovereignSecurity_CFLAGS = -fobjc-arc

# --- الحل السحري لمشكلة التثبيت ---
# هذا السطر يضبط محاذاة الذاكرة لتتوافق مع الحقن اليدوي
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk
