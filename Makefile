# المعماريات المستهدفة
ARCHS = arm64

# استهداف أحدث الأنظمة لضمان التوافق الأمني
TARGET = iphone:clang:latest:13.0

# نمط الروتلس (IPA Injection)
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SovereignSecurity
SovereignSecurity_FILES = SovereignSecurity.m

# تفعيل أقصى درجات التحسين ومنع الـ Strip
SovereignSecurity_CFLAGS = -fobjc-arc -O3 -Wno-deprecated-declarations

# المكتبات الضرورية للرسم، التشفير، والذاكرة
SovereignSecurity_FRAMEWORKS = UIKit Foundation Security CoreGraphics QuartzCore AudioToolbox

# سطر السيادة: تأمين الذاكرة عبر محاذاة القطاعات وتشفير الروابط
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000 -ldl

include $(THEOS_MAKE_PATH)/tweak.mk
