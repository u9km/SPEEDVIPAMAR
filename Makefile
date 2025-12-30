# تحديد الأجهزة المستهدفة (64-bit ضروري للألعاب الحديثة)
ARCHS = arm64

# استهداف إصدار iOS متوافق لضمان الاستقرار ومنع الكراش
TARGET = iphone:clang:latest:12.0

# وضع الروتلس (ضروري للحقن داخل ملف الـ IPA بدون جلبريك)
THEOS_PACKAGE_SCHEME = rootless

# تضمين ملفات بناء الثيوس الأساسية
include $(THEOS)/makefiles/common.mk

# اسم التويك (يجب أن يتطابق مع الملفات الناتجة)
TWEAK_NAME = SovereignSecurity

# تحديد الملف البرمجي الذي يحتوي على كود الكشف (تأكد من تسمية ملفك بهذا الاسم)
SovereignSecurity_FILES = SovereignSecurity.m

# إعدادات المترجم (استخدام ARC لإدارة الذاكرة تلقائياً لمنع اللاق)
SovereignSecurity_CFLAGS = -fobjc-arc

# فريمورك الرسم (ضروري جداً لعمل الـ ESP والظهور على الشاشة)
SovereignSecurity_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore

# أهم سطر لمنع الكراش عند فتح اللعبة بعد الحقن اليدوي
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000

# تضمين ملف بناء التويك النهائي
include $(THEOS_MAKE_PATH)/tweak.mk
