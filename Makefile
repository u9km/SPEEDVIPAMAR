# إعدادات المعمارية المستهدفة (iOS)
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

# اسم التويك (Tweak)
TWEAK_NAME = SovereignSecurity

# ملفات السورس (أضف أي ملفات .m أخرى هنا)
SovereignSecurity_FILES = SovereignSecurity.m

# الأطر العمل (Frameworks) المطلوبة
SovereignSecurity_FRAMEWORKS = Foundation UIKit CoreGraphics CoreML

# إعدادات المترجم (تجاهل بعض التحذيرات إذا لزم الأمر)
SovereignSecurity_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
