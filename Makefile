# تحديد المعماريات (arm64 ضرورية للأجهزة الحديثة 64-بت)
ARCHS = arm64

# استهداف إصدار نظام مستقر لضمان عمل واجهة UIKit بدون كراش
TARGET = iphone:clang:latest:12.0

# نمط الروتلس (مطلوب للحقن اليدوي في ملفات IPA بدون جلبريك)
THEOS_PACKAGE_SCHEME = rootless

# تضمين ملفات تعريف Theos الأساسية
include $(THEOS)/makefiles/common.mk

# اسم التويك الناتج (سيتم إنتاج ملف SovereignSecurity.dylib)
TWEAK_NAME = SovereignSecurity

# تحديد ملف الكود المدمج (تأكد من تسمية ملفك بهذا الاسم في GitHub)
SovereignSecurity_FILES = SovereignSecurity.m

# إعدادات المترجم (تفعيل ARC لإدارة الذاكرة تلقائياً ومنع اللاق)
SovereignSecurity_CFLAGS = -fobjc-arc

# المكتبات الضرورية جداً لرسم الزر العائم والمنيو والاهتزاز
SovereignSecurity_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore AudioToolbox

# سطر منع الكراش عند بدء التشغيل وتعديل مواءمة القطاعات للحقن اليدوي
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000

# إنهاء بناء التويك
include $(THEOS_MAKE_PATH)/tweak.mk
