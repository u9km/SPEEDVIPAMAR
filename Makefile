TARGET = iphone:clang:latest:14.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

# تحويل المشروع إلى إطار عمل (Framework)
FRAMEWORK_NAME = SovereignSecurity

# ملفات الكود
SovereignSecurity_FILES = SovereignSecurity.m

# إعدادات التثبيت (وهمية لأننا سنحقنه يدوياً)
SovereignSecurity_INSTALL_PATH = /Library/Frameworks

# المكتبات المطلوبة
SovereignSecurity_CFLAGS = -fobjc-arc
SovereignSecurity_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/framework.mk
